//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Pavel Nikipelov on 12.03.2024.
//

@testable import ImageFeed

import XCTest
import Foundation

final class ImageFeedTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testExample() throws { }

    func testPerformanceExample() throws { measure { } }
}
