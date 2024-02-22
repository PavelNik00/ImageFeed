import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Public Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    // массив содержащий имена изображений
    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    
    // сервис для получения и управления списком фотографий
    private let imagesListService = ImagesListService.shared
    
    // массив для хранения объектов Photo предоставляющих полученные фотографии
    private var photos: [Photo] = []
    
    // наблюдатель для изменениями в ImagesListService
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // форматирование даты для отображения
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // создаем вставку контента для таблицы
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        // добавляем наблюдатель за изменениями в ImagesLustService
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                // обновляем таблицу с анимацией при изменении сервиса
                self.updateTableViewAnimated()
            }
        
        // получение следующей страницы фотографии при запуске View
        imagesListService.fetchPhotosNextPage()
    }
    
    // подготовка к переходу к SingleImageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            if let viewController = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath,
               indexPath.row < photosName.count {
                let imageName = photosName[indexPath.row]
                let image = UIImage(named: "\(imageName)_full_size") ?? UIImage(named: imageName)
                viewController.image = image
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    // количество строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    // конфигурация каждой ячейки в таблице
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // получение повторно использованной ячейки с идентификатором
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        // проверка ячейки на соответствие типо ImagesListCell
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        // конфигурируем ячейку данными
        configCell(for: imageListCell, with: indexPath)
        
        // возвращаем ячейку
        return imageListCell
    }
    
    // конфигурация ячейки данными
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        // получаем изображение из массива photos по текущему индексу
        let image = photos[indexPath.row]
        
        // извлекаем URL миниатюры изображения из строки в объекте Photo
        guard let thumbnailURL = URL(string: image.thumbImageURL) else { return }
        
        // устанавливаем стиль выделения для ячейки (задаем отключение выделения)
        cell.selectionStyle = .none
        
        // конфигурируем Kingfisher для асинхронной загрузки и кэширования изображения
        // устанавливаем индикатор загрузки
        cell.cellImage.kf.indicatorType = .activity
        // указываем url изображения
        cell.cellImage.kf.setImage(with: thumbnailURL,
                                   placeholder: UIImage(named: "FeedImagePlaceholder")) { [weak self] _ in
            // замыкание выполняется после загрузки изображения
            guard let self = self else { return }
            // перезагружаем строку в таблице после загрузки изображения
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        // установка даты в ячейку
        let createdDate = image.createdAt
        // если дата существует то форматируем и устанавливаем ее, если нет - оставляем пустым
        cell.dateLabel.text = createdDate != nil ? dateFormatter.string(from: Date()) : ""
        
        // установка изображения лайка
//        let isLiked = indexPath.row % 2 == 0
        let likeImage = image.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
        
    }
    
    // Объявление метода делегата, который будет вызван перед отображением ячейки в таблице.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Получаем общее количество строк в секции таблицы
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        // Проверяем, является ли текущая ячейка последней в секции (Это обычно означает, что пользователь прокрутил таблицу до конца.)
        if indexPath.row == numberOfRows - 1 {
            // Если текущая ячейка последняя, вызываем метод fetchPhotosNextPage() у объекта imageListService. Этот метод загружает следующую порцию фотографий, когда пользователь достигает конца текущего списка.
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    // высота каждой строки в таблице
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // получаем изображение из массива photos по текущему индексу
        let image = photos[indexPath.row]
        
        // рассчитываем высоту ячейки на основе размера изображения и ширины таблицы
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    // обновление таблицы с анимацией
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    // обработка выбора строки в таблице
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // выполняем передох для отображения одного изображения при выборе строки
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

