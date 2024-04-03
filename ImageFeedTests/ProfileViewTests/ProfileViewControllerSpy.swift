//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Pavel Nikipelov on 28.03.2024.
//

import Foundation
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    
    func updateAvatar() {
        
    }
}
