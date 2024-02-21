import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Public Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    
    private let imagesListService = ImagesListService.shared
    
    private var photos: [Photo] = []
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        
        imagesListService.fetchPhotosNextPage()
    }
    
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

// MARK: - Extension
//extension ImagesListViewController {
//    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
//        let image = photos[indexPath.row]
//        guard let thumbnailURL = URL(string: image.thumbImageURL) else { return }
//        
//        cell.selectionStyle = .none
//        
//        cell.cellImage.kf.indicatorType = .activity
//        cell.cellImage.kf.setImage(with: thumbnailURL,
//                                   placeholder: UIImage(named: "FeedImagePlaceholder")) { [weak self] _ in
//            guard let self = self else { return }
//            self.tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//        
//        let createdDate = image.createdAt
//        cell.dateLabel.text = createdDate != nil ? dateFormatter.string(from: Date()) : ""
//        
//        let isLiked = indexPath.row % 2 == 0
//        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
//        cell.likeButton.setImage(likeImage, for: .normal)
//    }
//}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let image = photos[indexPath.row]
        guard let thumbnailURL = URL(string: image.thumbImageURL) else { return }
        
        cell.selectionStyle = .none
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: thumbnailURL,
                                   placeholder: UIImage(named: "FeedImagePlaceholder")) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let createdDate = image.createdAt
        cell.dateLabel.text = createdDate != nil ? dateFormatter.string(from: Date()) : ""
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

