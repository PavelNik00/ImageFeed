//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Pavel Nikipelov on 06.03.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения

    // функция запуска приложения
    override func setUpWithError() throws {

        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнение тестов, если в тесте что-то пошло не так
        
        app.launch() //запускаем приложение перед каждым тестом
    }

    func testAuth() throws {
        // тестируем сценарий авторизации
        
        /*
         У приложения мы получаем список кнопок на экране и получаем нужную кнопку по тексту на ней
         Далее вызываем функцию tap() для нажатия на этот элемент
         */
        
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
        webView.swipeUp() // поможет скрыть клавиатуру после ввода текста
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element // найдет поле для ввода пароля
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5)) // подождет 5 секунд, пока passwordTextField не появится
        
        passwordTextField.tap() // тап по окну логина
        passwordTextField.typeText("") // введет текст в поле ввода
        webView.swipeUp() // поможет скрыть клавиатуру после ввода текста
        
        // Нажать кнопку логина
        webView.buttons["Login"].tap()
        
        print(app.debugDescription) // печатает в консоли дерево UI-элементов (для отладки и выявления проблем)
        
        let tablesQuery = app.tables // вернет таблицы на экран
        
        tablesQuery.children(matching: .cell).element(boundBy: 0) // вернет ячейку по индексу О
        
        // Подождать, пока открывается экран ленты
        XCTAssertTrue(cell.waitForExistence(timeout: 5)) //подождем появление ячейки на экране в течении 5 минут
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        
        let tablesQuery = app.tables // вернет табилцы на экране
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0) // вернет ячейку по индексу 0
        
        cell.swipeUp() // метод для осуществления скроллинга
        
        sleep(2) // ожидание
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like_button_on"].tap()
        cellToLike.buttons["like_button_off"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0) // вернет первую картинку на scrollView
        image.pinch(withScale: 3, velocity: 1) // zoom in
        image.pinch(withScale: 0.5, velocity: -1) // zoom out
        
        let navBackButtonWhiteButton = app.buttons["nav_back_button"]
        navBackButtonWhiteButton.tap()
        
        // Подождать, пока открывается и загружается экран ленты
        // Сделать жест «смахивания» вверх по экрану для его скролла
        // Поставить лайк в ячейке верхней картинки
        // Отменить лайк в ячейке верхней картинки
        // Нажать на верхнюю ячейку
        // Подождать, пока картинка открывается на весь экран
        // Увеличить картинку
        // Уменьшить картинку
        // Вернуться на экран ленты
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
    }
}
