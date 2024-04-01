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
    
    private func launch() {
        app.launch()
    }
    
    // тестируем сценарий авторизации
    func testAuth() throws {
        
        let userMail = "user mail"
        let userMailPassword = "user mail password"
        
        // Нажать кнопку авторизации
        app.buttons["Autentificate"].tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"] // вернёт нужный WebView по accessibilityIdentifier
        XCTAssertTrue(webView.waitForExistence(timeout: 5)) // подождет 5 секунд, пока WebView не появится
        
        // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element // найдет поле для ввода логина
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5)) // подождет 5 секунд, пока loginTextField не появится
        
        loginTextField.tap() // тап по окну логина
        loginTextField.typeText(userMail) // введет текст в поле ввода
        
        // Нажать клавишу "Done", чтобы закрыть клавиатуру
        app.buttons["Done"].tap()
        webView.swipeUp() // поможет скрыть клавиатуру после ввода текста
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element // найдет поле для ввода пароля
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5)) // подождет 5 секунд, пока passwordTextField не появится
        
        passwordTextField.tap() // тап по окну пароля
        passwordTextField.typeText(userMailPassword) // введет текст в поле ввода
        
        webView.swipeUp() // поможет скрыть клавиатуру после ввода текста
        
        // Нажать кнопку логина
        webView.buttons["Login"].tap()
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        print(app.debugDescription)
    }
    
    // тестируем сценарий ленты
    func testFeed() throws {
        // Подождать, пока открывается и загружается экран ленты
        // Сделать жест «смахивания» вверх по экрану для его скролла
        // Поставить лайк в ячейке верхней картинки
        // Отменить лайк в ячейке верхней картинки
        // Нажать на верхнюю ячейку
        // Подождать, пока картинка открывается на весь экран
        // Увеличить картинку
        // Уменьшить картинку
        // Вернуться на экран ленты
        
        launch()
        
        // Подождать, пока открывается и загружается экран ленты
        let tablesQuery = app.tables // вернет таблицы на экране
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0) // вернет ячейку по индексу 0
        
        cell.swipeUp() // метод для осуществления скроллинга
        sleep(2) // ожидание
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        sleep(2)
        
        // нажатие на лайк - постановка
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        
        // нажатие на лайк - отмена
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        
        // нажатие на верхнюю картинку
        cell.tap()
        sleep(2)
        
        // увеличение картинки
        let image = app.scrollViews.images.element(boundBy: 0) // вернет первую картинку на scrollView
        image.pinch(withScale: 3, velocity: 1) // zoom in
        image.pinch(withScale: 0.5, velocity: -1) // zoom out
        
        // вернет экран ленты
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
        
        // переход на экран профиля
        app.tabBars.buttons.element(boundBy: 1).tap() // нажмем таб с индексом 1 на tabbar
        
        // Проверить что на нем отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts[userName].exists)
        XCTAssertTrue(app.staticTexts[userLogin].exists)
        XCTAssertTrue(app.staticTexts[userBio].exists)
        
        // Нажать кнопку логаута
        let logoutButton = app.buttons["logoutButton"]
        logoutButton.tap()
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 5))
        
        // Нажать на Да в алерте
        let alert = app.alerts["Пока, пока!"]
        XCTAssert(alert.waitForExistence(timeout: 5))
        
        alert.buttons["Да"].tap()
        //        XCTAssert(alert.waitForExistence(timeout: 5))
        
        sleep(2)
        
        // Нажать кнопку авторизации
        app.buttons["Autentificate"].tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"] // вернёт нужный WebView по accessibilityIdentifier
        XCTAssertTrue(webView.waitForExistence(timeout: 5)) // подождет 5 секунд, пока WebView не появится
        
        print(app.debugDescription)
    }
}
