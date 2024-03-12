//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 23.01.2024.
//

import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - Properties
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - IB Outlets
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: - Private Properties
    private let identitfier = "WebViewViewController"
    private var estimatedProgressObservation: NSKeyValueObservation?
    //    private var alertPresenter: AlertPresenter?
    
//    fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.accessibilityIdentifier = "UnsplashWebView"
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        progressObservation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
//        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil
        )
    }
    
    // MARK: - Func
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Public Methods
//    func load(request: URLRequest) {
//        webView.load(request)
//    }
    
    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        showNetworkError()
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    private func progressObservation() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress, options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             }
        )
    }
    
    // MARK: - IB Action
    @IBAction private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

// MARK: - Extension
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    // добавили вызов презентера для анализа URL
        private func code(from navigationAction: WKNavigationAction) -> String? {
            if let url = navigationAction.request.url {
                return presenter?.code(from: url)
            }
            return nil
        }
}

//MARK: - AlertPresenter
extension WebViewViewController {
    private func showNetworkError() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ок"
        ) { [weak self] isConfirmed in
            guard let self else { return }
            if isConfirmed {
                dismiss(animated: true)
            }
        }
        //        alertPresenter = AlertPresenter(delegate: self)
        AlertPresenter.showAlert(for: alert, in: self)
    }
}

extension WebViewViewController: WebViewViewControllerProtocol {
    func load(request: URLRequest) {
        webView.load(request)
    }
}
