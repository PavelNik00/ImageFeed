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
        
        // Подождать, пока открывается и загружается экран ленты
        let tablesQuery = app.tables // вернет таблицы на экране
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0) // вернет ячейку по индексу 0
        
        cell.swipeUp() // метод для осуществления скроллинга
        sleep(2) // ожидание
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        sleep(2)
        
        // нажатие на лайк - постановка
        cellToLike.buttons["like_button_on"].tap()
        sleep(2)
        
        // нажатие на лайк - отмена
        cellToLike.buttons["like_button_off"].tap()
        sleep(2)
        
        // нажатие на верхнюю картинку
        cellToLike.tap()
        sleep(2)
        
        // увеличение картинки
        let image = app.scrollViews.images.element(boundBy: 0) // вернет первую картинку на scrollView
        image.pinch(withScale: 3, velocity: 1) // zoom in
        image.pinch(withScale: 0.5, velocity: -1) // zoom out
        
        // вернет экран ленты
        let navBackButton = app.buttons["nav_back_button"]
        navBackButton.tap()
    }
    
    // тестируем сценарий профиля
    func testProfile() throws {
        // Подождать, пока открывается и загружается экран ленты
        // Перейти на экран профиля
        // Проверить, что на нём отображаются ваши персональные данные
        // Нажать кнопку логаута
        // Проверить, что открылся экран авторизации
        
        sleep(2)

        // переход на экран профиля
        app.tabBars.buttons.element(boundBy: 0).tap() // нажмем таб с индексом 0 на tabbar
        
        // Проверить что на нем отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts["Name Label"].exists)
        XCTAssertTrue(app.staticTexts["NickName Label"].exists)
        XCTAssertTrue(app.staticTexts["Text Label"].exists)
        
        // Нажать кнопку логаута
        let logoutButton = app.buttons["logoutButton"]
        logoutButton.tap()
        
        // Нажать на Да в алерте
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        // Проверить что открылся экран авторизации
        let authView = app.otherElements["AuthViewController"]
        XCTAssertTrue(authView.waitForExistence(timeout: 1))
    }
}
