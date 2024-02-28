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
            guard isViewLoaded else { return }
            rescaleAndCenterImageInScrollView(image: image ?? UIImage() )
        }
    }
    
    var fullImageURL: URL?
    
    //    private var alertPresenter: AlertPresenter?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var sharedButton: UIButton!
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        setImageWithURL()
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
    
    // MARK: - IB Action
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
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
        imageView
    }
}

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
