//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Pavel Nikipelov on 28.03.2024.
//

import Foundation
import ImageFeed
import UIKit

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var updateAvatarCalled: Bool = false
    var logoutButtonTapped: Bool = false
    var observer: Bool = false
    var viewController: ProfileViewControllerProtocol?
    
    
    func showLogoutAlert(in viewController: UIViewController) {
        logoutButtonTapped = true
    }
    
    func addObserver() {
        observer = true
    }
    
    func updateAvatar() -> URL? {
        updateAvatarCalled = true
        return nil
    }
}
