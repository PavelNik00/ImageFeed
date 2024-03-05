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
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

    func viewDidLoad() {
        guard var urlComponents = URLComponents(string: unsplashAuthorizeURLString) else {
            print("Error: Unable to create URLComponents from string")
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]

        guard let url = urlComponents.url else {
            print("Error: Unable to create URL from URLComponents")
            return
        }

        let request = URLRequest(url: url)
        view?.load(request: request)
    }
}
