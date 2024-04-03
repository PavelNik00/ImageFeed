//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Pavel Nikipelov on 28.03.2024.
//

@testable import ImageFeed

import Foundation
import XCTest

final class ProfileViewTests: XCTestCase {
    
    // тест для метода добавления наблюдателя
    func testProfileViewPresenterAddObserver() {
        
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        // when
        viewController.viewDidLoad()
        presenter.addObserver()
        
        // then
        XCTAssert(presenter.observer)
    }
    
    // тест для метода добавления аватара
    func testProfileViewPresenterUpdateAvatar() {
        
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        //when
        viewController.viewDidLoad()
        presenter.updateAvatar()
        
        //then
        XCTAssertTrue(presenter.updateAvatarCalled)
    }
}
