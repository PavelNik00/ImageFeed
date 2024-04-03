//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 12.03.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    
    var view: WebViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: WebViewControllerProtocol?
    
    private let authHelper: AuthHelperProtocol
    
    // MARK: - Initializers
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        if let request = authHelper.authRequest() {
            view?.load(request: request)
        }
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
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
