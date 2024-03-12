//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 05.03.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    
    // презентер анализирует URL и достает из него код, если он есть
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    func viewDidLoad() {

        guard let request = authHelper.authRequest() else {
            assertionFailure("Failed to construct authorization URLRequest")
            return
        }
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    // презентер анализирует URL и достает из него код, если он есть, реализация метода
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
