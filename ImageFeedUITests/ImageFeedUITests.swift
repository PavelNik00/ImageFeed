//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Pavel Nikipelov on 12.03.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    // переменная приложения
    private let app = XCUIApplication()

    // функция запуска приложения
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // запуск приложения перед каждым тестом
        app.launch()
    }

    // тестируем сценарий авторизации
    func testAuth() throws {
        
        // Нажать кнопку авторизации
        app.buttons["Authenticate"].tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"] // вернёт нужный WebView по accessibilityIdentifier
        XCTAssertTrue(webView.waitForExistence(timeout: 5)) // подождет 5 секунд, пока WebView не появится
        
            // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element // найдет поле для ввода логина
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5)) // подождет 5 секунд, пока loginTextField не появится
        loginTextField.tap() // тап по окну логина
        loginTextField.typeText("") // введет текст в поле ввода
//        webView.swipeUp() // поможет скрыть клавиатуру после ввода текста
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element // найдет поле для ввода пароля
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5)) // подождет 5 секунд, пока passwordTextField не появится
        
        passwordTextField.tap() // тап по окну логина
        passwordTextField.typeText("") // введет текст в поле ввода
        
        webView.swipeUp() // поможет скрыть клавиатуру после ввода текста
        
        // Нажать кнопку логина
        webView.buttons["Login"].tap()
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
    }

}
