//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Pavel Nikipelov on 06.03.2024.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled) // проверка поведения
    }
    
    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testExample() throws { }

    func testPerformanceExample() throws { measure { } }
}
