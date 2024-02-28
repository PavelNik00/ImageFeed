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
    private let splashScreenLogo = UIImageView(image: UIImage(named: "splash_screen_logo"))
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let mainID = "Main"
    private let authViewControllerID = "AuthViewController"
    private let tabBarViewControllerID = "TabBarViewController"
    private var alertPresenter: AlertPresenter?
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.token != nil {
            guard let token = oauth2TokenStorage.token else { return }
            fetchProfile(token: token)
        } else {
            switchToAuthViewController()
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
    
    private func updateSplashScreenLogo() {
        splashScreenLogo.translatesAutoresizingMaskIntoConstraints = false
        splashScreenLogo.heightAnchor.constraint(equalToConstant: 77).isActive = true
        splashScreenLogo.widthAnchor.constraint(equalToConstant: 75).isActive = true
        splashScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        splashScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(splashScreenLogo)
    }
}

// MARK: - Extentsion

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
                self.oauth2TokenStorage.token = token
                self.fetchProfile(token: token)
                self.switchToTabBarController()
            case .failure:
                self.showNetworkError()
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: mainID, bundle: .main)
            .instantiateViewController(withIdentifier: tabBarViewControllerID)
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let username = self.profileService.profile?.userName else { return }
                self.profileImageService.fetchProfileImageURL(username: username)  { _ in }
                DispatchQueue.main.async {
                    self.showToTabBarController()
                }
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
            completion: { [weak self] isConfirmed in
                guard self != nil else { return }
                if isConfirmed {
                    self?.switchToAuthViewController()
                }
            })
        AlertPresenter.showAlert(for: alert, in: self)
    }
}
