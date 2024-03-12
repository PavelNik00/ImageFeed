//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Pavel Nikipelov on 06.03.2024.
//

@testable import ImageFeed
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
    
//        let authenticateButton = app.buttons["Authenticate"]
//        XCTAssertTrue(authenticateButton.waitForExistence(timeout: 5), "Button 'Authenticate' not found")
//        authenticateButton.tap()
        
        sleep(2)
        
        // Нажать кнопку авторизации
        let authenticateButton = app.buttons["Войти"]
        XCTAssertTrue(authenticateButton.waitForExistence(timeout: 5), "Button 'Войти' not found")
        authenticateButton.tap()

            // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["WebViewViewController"] // вернёт нужный WebView по accessibilityIdentifier
        XCTAssertTrue(webView.waitForExistence(timeout: 2)) // подождет 5 секунд, пока WebView не появится
        
            // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element // найдет поле для ввода логина
        loginTextField.tap() // тап по окну логина
        sleep(2)
        loginTextField.typeText("pavelmdesign@gmail.com") // введет текст в поле ввода
        sleep(2)
        app.buttons["Done"].tap()
//        loginTextField.swipeUp() // поможет скрыть клавиатуру после ввода текста
        
        sleep(2)
        let passwordTextField = webView.descendants(matching: .secureTextField).element // найдет поле для ввода пароля
//        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5)) // подождет 5 секунд, пока passwordTextField не появится
        passwordTextField.tap() // тап по окну пароля
        sleep(2)
        app.typeText("Sahasrara1010") // введет текст в поле ввода
//        webView.swipeUp() // поможет скрыть клавиатуру после ввода текста
        sleep(2)
        app.buttons["Done"].tap()
        sleep(2)
        
        // Нажать кнопку логина
        webView.buttons["Login"].tap()
        
        // Подождать, пока открывается экран ленты
        sleep(2)
        let tablesQuery = app.tables // вернет таблицы на экран
        sleep(2)
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0) // вернет ячейку по индексу 0
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5)) //подождем появление ячейки на экране в течении 5 минут
        sleep(2)
        print(app.debugDescription) // печатает в консоли дерево UI-элементов (для отладки и выявления проблем)
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
        
        // Подождать, пока открывается и загружается экран ленты
        // Перейти на экран профиля
        // Проверить, что на нём отображаются ваши персональные данные
        // Нажать кнопку логаута
        // Проверить, что открылся экран авторизации
        
        sleep(3)

        app.tabBars.buttons.element(boundBy: 0).tap() // нажмем таб с индексом 0 на tabbar
        
        XCTAssertTrue(app.staticTexts["Pavel Krasnow"].exists)
        XCTAssertTrue(app.staticTexts["@pavel00nik"].exists)
        
        app.buttons["logout_button"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap() // наждем кнопку ОК на алерте с заголовкам Alert
        
//        app.staticTexts["Text"].exists // поле exists подскажет существует ли такой текст на экране
    }
}
