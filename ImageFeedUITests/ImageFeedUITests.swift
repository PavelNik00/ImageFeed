//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Pavel Nikipelov on 12.03.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication()
    

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    private func launch() {
        app.launch()
    }
    
    // тестируем сценарий авторизации
    func testAuth() throws {
        
        let userMail = "user mail"
        let userMailPassword = "user mail password"
        
        app.buttons["Autentificate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(userMail)
        
        // Нажать клавишу "Done", чтобы закрыть клавиатуру
        app.buttons["Done"].tap()
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(userMailPassword)
        
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        print(app.debugDescription)
    }
    
    // тестируем сценарий ленты
    func testFeed() throws {

        launch()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        cell.swipeUp()
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        sleep(2)
        
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        
        cell.tap()
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1) // zoom in
        image.pinch(withScale: 0.5, velocity: -1) // zoom out
        
        let navBackButton = app.buttons["backButton"]
        navBackButton.tap()
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        print(app.debugDescription)
    }
    
    // тестируем сценарий профиля
    func testProfile() throws {
        
        let userName = "user name"
        let userLogin = "user login"
        let userBio = "user bio"
        
        sleep(2)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[userName].exists)
        XCTAssertTrue(app.staticTexts[userLogin].exists)
        XCTAssertTrue(app.staticTexts[userBio].exists)
        
        let logoutButton = app.buttons["logoutButton"]
        logoutButton.tap()
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 5))
        
        let alert = app.alerts["Пока, пока!"]
        XCTAssert(alert.waitForExistence(timeout: 5))
        
        alert.buttons["Да"].tap()
        
        sleep(2)
        
        app.buttons["Autentificate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5)) 
        
        print(app.debugDescription)
    }
}
