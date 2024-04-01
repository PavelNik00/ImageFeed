//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 27.03.2024.
//

import Foundation
import UIKit
import Kingfisher

public protocol ProfileViewPresenterProtocol {
    func showLogoutAlert(in viewController: UIViewController)
    func addObserver()
    func updateAvatar() -> URL?
    
    var viewController: ProfileViewControllerProtocol? { get set }
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    // MARK: - Public properties
    weak var viewController: ProfileViewControllerProtocol?
    
    // MARK: - Private Properties
    private let profileImage = UIImageView(image: UIImage(named: "avatar"))
    
    // MARK: - Public Methods
    func addObserver() {
        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.viewController?.updateAvatar()
        }
    }
    
    func showLogoutAlert(in viewController: UIViewController) {
        
        let alert = AlertModelRepeat(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            buttonText: "Да",
            cancelButtonText: "Нет"
        ) { [weak self] isConfirmd in
            guard let self = self else { return }
            if isConfirmd {
                ProfileLogoutService.shared.logout()
                self.switchToSplashViewController()
            }
        }
        AlertPresenter.showAlert(for: alert, in: viewController)
    }
    
    func updateAvatar() -> URL? {
        if let profileImageURL = ProfileImageService.shared.avatarUrl,
           let url = URL(string: profileImageURL) {
            return url
        } else {
            print("Пришлa пустая ссылка на аватарку")
            return nil
        }
    }
    
    // MARK: - Private Methods
    private func switchToSplashViewController() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.showInitialScreen()
        }
    }
}

