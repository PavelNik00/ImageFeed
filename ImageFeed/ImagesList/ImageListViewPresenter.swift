//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 29.03.2024.
//

import Foundation

public protocol ImageListViewPresenterProtocol {
    
    var viewController: ImageListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    
    func fetchPhotos()
    func addObserver()
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func loadingNextPage(at indexPath: IndexPath, photosCount: Int)
    
}

final class ImageListViewPresenter: ImageListViewPresenterProtocol {
    
    weak var viewController: ImageListViewControllerProtocol?
    
    var imagesListServiceObserver: NSObjectProtocol?
    
    var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    
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
    
    private func handleDataChangeNotification() {
        let oldCount = viewController?.photos.count
        let newCount = imagesListService.photos.count
        viewController?.photos = imagesListService.photos
        updateTableViewAnimated(oldCount: oldCount ?? 0, newCount: newCount)
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
    

}
