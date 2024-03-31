//
//  ImagesListServisSpy.swift
//  ImageFeedTests
//
//  Created by Pavel Nikipelov on 31.03.2024.
//

@testable import ImageFeed
import Foundation
import UIKit

final class ImagesListPresenterSpy: ImageListViewPresenterProtocol {
    
    var fetchPhotosCalled = false
    var addObserverCalled: Bool = false
    var updateTableViewAnimatedCalled = false
    var loadingNextPageCalled = false
    var formatDateCalled = false
    var showLikeErrorCalled = false
    
    var imagesListServiceObserver: NSObjectProtocol?
    var viewController: ImageFeed.ImageListViewControllerProtocol?
    
    func fetchPhotos() {
        fetchPhotosCalled = true
    }
    
    func addObserver() {
        addObserverCalled = true
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
    
    func loadingNextPage(at indexPath: IndexPath, photosCount: Int) {
        loadingNextPageCalled = true
    }
    
    func formatDate(_ date: Date?) -> String {
        formatDateCalled = true
        return ""
    }
    
    func showLikeError(in viewController: UIViewController) {
        showLikeErrorCalled = true
    }
}
