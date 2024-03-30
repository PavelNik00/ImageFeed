import UIKit
import Kingfisher

public protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListViewPresenterProtocol? { get set }
    var photos: [Photo] { get set }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
}

final class ImagesListViewController: UIViewController, ImageListViewControllerProtocol {
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    var presenter: ImageListViewPresenterProtocol?
    
    // MARK: - Public Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    
    private let imagesListService = ImagesListService.shared
    
    var photos: [Photo] = []
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private var alertPresenter: AlertModelProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUpTable()
        configurePresenter()
        presenter?.fetchPhotos()
        presenter?.addObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            if let viewController = segue.destination as? SingleImageViewController,
               let indexPath = sender as? IndexPath, 
                indexPath.row < photos.count {
                viewController.image = UIImage()
                let imageUrl = photos[indexPath.row].largeImageURL
                guard let fullImageURL = URL(string: imageUrl) else { return }
                viewController.fullImageURL = fullImageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController {
    
    private func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func configurePresenter() {
        presenter = ImageListViewPresenter()
        presenter?.viewController = self
    }
}

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
        cell.dateLabel.text = createdDate != nil ? dateFormatter.string(from: createdDate!) : ""
        
        let likeImage = image.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
        
        cell.delegate = self
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                presenter?.loadingNextPage(at: indexPath, photosCount: photos.count)
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
}

extension ImagesListViewController {
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        guard oldCount != newCount else { return }
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }


// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showLikeError()
            }
        }
    }
}

extension ImagesListViewController {
    
    private func showLikeError() {
        
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить или убрать лайк",
            buttonText: "ОК"
        ) { [weak self] isConfirmed in
            guard let self = self else { return }
            if isConfirmed {
                self.dismiss(animated: true)
            }
        }
        AlertPresenter.showAlert(for: alert, in: self)
    }
}
