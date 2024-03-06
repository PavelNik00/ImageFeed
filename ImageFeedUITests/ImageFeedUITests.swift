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
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
    }
}
