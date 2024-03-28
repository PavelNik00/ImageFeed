//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 27.03.2024.
//

import Foundation
import UIKit

public protocol ProfileViewPresenterProtocol {
    func showLogoutAlert(in viewController: UIViewController)

    var viewController: ProfileViewControllerProtocol? { get set }
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    // MARK: - Public properties
    weak var viewController: ProfileViewControllerProtocol?
    
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
    
    private func switchToSplashViewController() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.showInitialScreen()
        }
    }
}

