//
//  ImageListViewTests.swift
//  ImageFeedTests
//
//  Created by Pavel Nikipelov on 31.03.2024.
//

import Foundation

@testable import ImageFeed
import XCTest

final class ImageListViewTests: XCTestCase {
    
    func testFetchPhotos() {
        // given
        let presenter = ImagesListPresenterSpy()
        
        // when
        presenter.fetchPhotos()
        
        // then
        XCTAssertTrue(presenter.fetchPhotosCalled)
    }

    func testObserver() {
        // given
        let presenter = ImagesListPresenterSpy()

        // when
        presenter.addObserver()

        // then
        XCTAssertNotNil(presenter.addObserverCalled)
    }
    
    func testUpdateTableViewAnimated() {
        // given
        let oldCountPresenter = 1
        let newCountPresenter = 2
        let presenter = ImageListViewPresenter()
        let view = ImagesListViewControllerSpy()
        presenter.viewController = view

        // when
        presenter.updateTableViewAnimated(oldCount: oldCountPresenter, newCount: newCountPresenter)

        // then
        XCTAssertTrue(view.didCallUpdateTableViewAnimated)
        XCTAssertEqual(view.newCountView, newCountPresenter)
        XCTAssertEqual(view.oldCountView, oldCountPresenter)
    }
    
    func testLoadingNextPage() {
        // Given
        let spy = ImagesListPresenterSpy()
        let indexPath = IndexPath(row: 4, section: 0)
        let photosCount = 5
        
        // When
        spy.loadingNextPage(at: indexPath, photosCount: photosCount)
        
        // Then
        XCTAssertTrue(spy.loadingNextPageCalled)
    }

    func testFormatDate() {
        // given
        let presenter = ImagesListPresenterSpy()

        // when
        let date = presenter.formatDate(nil)

        // then
        XCTAssertEqual("", date)
    }
    
    func testShowLikeError() {
        // Given
        let presenter = ImagesListPresenterSpy()

        // When
        presenter.showLikeError(in: UIViewController())
        
        // Then
        XCTAssertTrue(presenter.showLikeErrorCalled)
    }
}
