//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 30.01.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private Properties
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let mainID = "Main"
    private let authViewControllerID = "AuthViewController"
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Private Func
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

// MARK: - Extension
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: mainID, bundle: .main).instantiateViewController(
            identifier: authViewControllerID
        )
        guard let authViewController = storyboard as? AuthViewController else {
            assertionFailure("Failed to show Authentication Screen")
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
//                self.fetchProfile(token)
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                // TODO [Sprint 11] Показать ошибку
                break
            }
        }
    }
    
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let username = self.profileService.profile?.userName else { return }
                self.profileImageService.fetchProfileImageURL(username: username)  { _ in }
//                DispatchQueue.main.async {
//                    self.showToTabBarController()
//                }
            case .failure:
                self.showNetworkError()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

// MARK: - AlertPresenter

extension SplashViewController {
    private func showNetworkError() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "ОК",
            completion: { [weak self] in
                guard self != nil else {
                    return
                }
                self?.switchToAuthViewController()
            })
        alertPresenter?.showError(for: alert)
    }
}
