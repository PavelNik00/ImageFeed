//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 29.03.2024.
//

import Foundation
import UIKit

public protocol ImageListViewPresenterProtocol {
    
    var viewController: ImageListViewControllerProtocol? { get set }
    
    func fetchPhotos()
    func addObserver()
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func loadingNextPage(at indexPath: IndexPath, photosCount: Int)
    func formatDate(_ date: Date?) -> String
    func showLikeError(in viewController: UIViewController)
}

final class ImageListViewPresenter: UIViewController, ImageListViewPresenterProtocol {
    
    // MARK: - Public Properties
    weak var viewController: ImageListViewControllerProtocol?
    
    var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Private Properties
    private var alertPresenter: AlertModelProtocol?
    
    private let imagesListService = ImagesListService.shared
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Public Methods
    
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func addObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.handleDataChangeNotification()
            }
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        viewController?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
    }
    
    func loadingNextPage(at indexPath: IndexPath, photosCount: Int)  {
        if indexPath.row + 1 == photosCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.fetchPhotos()
            }
        }
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
    
    func showLikeError(in viewController: UIViewController) {
        
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
        AlertPresenter.showAlert(for: alert, in: viewController)
    }
    
    // MARK: - Private Methods
    private func handleDataChangeNotification() {
        let oldCount = viewController?.photos.count
        let newCount = imagesListService.photos.count
        viewController?.photos = imagesListService.photos
        updateTableViewAnimated(oldCount: oldCount ?? 0, newCount: newCount)
    }
}
