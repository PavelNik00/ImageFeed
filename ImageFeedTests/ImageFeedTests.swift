//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Pavel Nikipelov on 06.03.2024.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {

    // тест для проверки вызова viewDidLoad презентера и вьюконтроллера
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
    
    // тест проверки вызова метода loadRequest вьюконтроллера после вызова presenter.viewDidLoad()
    func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    // тест для проверки значения прогресса равной меньше 1
    func testProgressVisibleWhenLessThenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // then
        XCTAssertFalse(shouldHideProgress)
    }
    
    // тест для проверки значения прогресса равной 1
    func testProgressHiddenWhenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // then
        XCTAssertTrue(shouldHideProgress)
    }
    
    // тест для проверки что ссылка, полученная из authURL содержит все необходимые компоненты
    func testAuthHelperAuthURL() {
        // given
        let configuration = AuthConfiguration.standart
        let authHelper = AuthHelper(configuration: configuration)
        
        // when
        let url = authHelper.authURL()
        let urlString = url!.absoluteString
        
        // then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))

    }
    
    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testExample() throws { }

    func testPerformanceExample() throws { measure { } }
}
