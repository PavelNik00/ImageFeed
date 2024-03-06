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
    
//    fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

    func viewDidLoad() {
//        guard var urlComponents = URLComponents(string: AuthConfiguration.standart.authURLString)
//        else {
//            assertionFailure("Invalid authorization URL string: \(AuthConfiguration.standart.authURLString)")
//            return
//        }
//
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: Constants.accessScope)
//        ]
//
//        guard let url = urlComponents.url else {
//            assertionFailure("Failed to construct authorization URLRequest with components: \(urlComponents)")
//            return
//        }

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
//           if let urlComponents = URLComponents(string: url.absoluteString),
//            urlComponents.path == "/oauth/authorize/native",
//            let items = urlComponents.queryItems,
//            let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
    }
}
