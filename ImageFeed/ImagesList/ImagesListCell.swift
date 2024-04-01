import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - IB Outlets
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            likeButton.accessibilityIdentifier = "likeButton"
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var gradient: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - IB Actions
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let buttonImage = isLiked  ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(buttonImage, for: .normal)
    }
}
