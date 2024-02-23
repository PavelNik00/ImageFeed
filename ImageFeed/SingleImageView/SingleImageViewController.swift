//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 04.01.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var image: UIImage! {
        didSet {
            // Обновляем изображение во вью контроллере при изменении значения
            guard isViewLoaded else { return }
            rescaleAndCenterImageInScrollView(image: image ?? UIImage() )
        }
    }
    
    var fullImageURL: URL?
    
    private var alertPresenter: AlertPresenterRepeatProtocol?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var sharedButton: UIButton!
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Настройка минимального и максимального уровней масштабирования для scrollView
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        // Загрузка изображения по URL
        setImageWithURL()
//        imageView.image = image
//        rescaleAndCenterImageInScrollView(image: image ?? UIImage())
    }
    
    // MARK: - Private func
    
    // Расчет и установка масштаба и смещения изображения в scrollView
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func setImageWithURL() {
        guard let fullImageURL else { return }
        // Показываем индикатор загрузки
        UIBlockingProgressHUD.show()
        // Загружаем изображение по URL с использованием Kingfisher
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            // Скрываем индикатор загрузки
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                // Устанавливаем загруженное изображение
                self.image = imageResult.image
            case .failure:
                // Показываем алерт об ошибке
                self.showError()
            }
        }
    }
    
    // MARK: - IB Action
    @IBAction func didTapBackButton() {
        // Закрываем текущий view controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        // Подготавливаем и показываем контроллер для общего доступа к изображению
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // Возвращаем изображение для поддержки масштабирования в scrollView
        imageView
    }
}

extension SingleImageViewController {
    
    // Функция для показа алерта с опцией повторить
    private func showError() {
        
        // создаем модель алерта
        let alert = AlertModelRepeat(
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: "Не удалось загрузить картинку",
            buttonText: "Повторить",
            cancelButtonText: "Не надо"
            ) { [weak self] in
                guard let self else { return }
                // Вызываем функцию для повторного запроса на загрузку изображения
                self.setImageWithURL()
                // закрываем алерт при нажатии на кнопку
//                self.dismiss(animated: true)
            }
        // инициализируем презентер алертов и присваиваем его свойству alertPresenter
        alertPresenter = AlertPresenter(delegate: self)
        
        // отображаем алерт
        alertPresenter?.showError(for: alert)
    }
}
