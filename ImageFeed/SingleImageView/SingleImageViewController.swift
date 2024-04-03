//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 04.01.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var sharedButton: UIButton!
    @IBOutlet private weak var likeCircleButton: UIButton!
    
    // MARK: - Public Properties
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            rescaleAndCenterImageInScrollView(image: image ?? UIImage() )
        }
    }
    
    var fullImageURL: URL?
    
    // MARK: - Private Properties
    private let backButton = UIButton(type: .custom)
    private let circleLikeButton = UIButton(type: .custom)
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        setupBackButton()
        setupCircleLikeButton()
        setImageWithURL()
    }
    
    // MARK: - IB Action
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func circleButtonClicked() {
    }
    
    
    @IBAction func didTapShareButton(_ sender: Any) {
        // Создаем экземпляр контроллера UIActivityViewController
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil
        )
        
        // Задаем стиль контроллера
            if #available(iOS 13.0, *) {
                share.overrideUserInterfaceStyle = .dark
            }

         // Создаем активности AirDrop и отправки контактов
        if #available(iOS 16.4, *) {
            share.excludedActivityTypes = [
                UIActivity.ActivityType.airDrop,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.addToHomeScreen
            ]
        } else {
            // Fallback on earlier versions
        }
        
        share.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                print("It is done!")
            }
        }
        
        // Показываем контроллер
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - Public func
    func setImageWithURL() {
        guard let fullImageURL else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
            case .failure:
                self.showError()
            }
        }
    }
    
    // MARK: - Private func
    
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
    
    private func setupBackButton() {
        guard let image = UIImage(named: "BackwardWhite", in: Bundle.main, compatibleWith: nil) else {
            return
        }
        
        backButton.accessibilityIdentifier = "backButton"
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        
    }
    
    private func setupCircleLikeButton() {
        guard let image = UIImage(named: "like_circleButton_off", in: Bundle.main, compatibleWith: nil) else {
            return
        }
        
        circleLikeButton.accessibilityIdentifier = "like_circleButton_off"
        circleLikeButton.setImage(image, for: .normal)
        circleLikeButton.addTarget(self, action: #selector(circleButtonClicked), for: .touchUpInside)
        circleLikeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circleLikeButton)
        
        circleLikeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 51).isActive = true
        circleLikeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -36).isActive = true
        
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: - Extension

extension SingleImageViewController {
    
    private func showError() {
        let alert = AlertModelRepeat(
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: "Не удалось загрузить картинку",
            buttonText: "Повторить",
            cancelButtonText: "Не надо"
        ) { [weak self] isConfirmed in
            guard let self else { return }
            if isConfirmed {
                self.setImageWithURL()
            }
        }
        AlertPresenter.showAlert(for: alert, in: self)
    }
}
