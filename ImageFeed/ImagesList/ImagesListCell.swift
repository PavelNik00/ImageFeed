import UIKit
import Kingfisher

// Протокол делегата для обработки событий в ячейке ImagesListCell
protocol ImagesListCellDelegate: AnyObject {
    // Метод, вызываемый при нажатии на кнопку "лайк" в ячейке
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

// Класс, представляющий ячейку в списке изображений
final class ImagesListCell: UITableViewCell {
    
    // MARK: - Public Properties
    // Идентификатор ячейки для использования при регистрации и повторном использовании
    static let reuseIdentifier = "ImagesListCell"
    
    // Слабая ссылка на делегата, который будет обрабатывать события в ячейке
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - IB Outlets
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var gradient: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - IB Actions
    // Обработчик нажатия на кнопку "лайк"
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }

    // Устанавливает изображение лайка в зависимости от его статуса
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            // Если лайк поставлен, устанавливаем изображение лайка в состояние "включен"
            let likeOnImage = UIImage(named: "like_button_on")
            likeButton.setImage(likeOnImage, for: .normal)
        } else {
            // Если лайк не поставлен, устанавливаем изображение лайка в состояние "выключен"
            let likeOffImage = UIImage(named: "like_button_off")
            likeButton.setImage(likeOffImage, for: .normal)
        }
    }
}
