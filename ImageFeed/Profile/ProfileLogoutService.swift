//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 23.02.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    
    // MARK: - Public Properties
    static let shared = ProfileLogoutService()
    
    // MARK: - Initializers
    private init() { }
    
    // MARK: - Public Methods
    func logout() {
        cleanCookies()
        clearProfile()
        clearProfileAvatar()
        clearPhotos()
        clearToken()
    }
    
    // MARK: - Private Methods
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func clearProfile() {
        ProfileService.shared.clearProfile()
    }
    
    private func clearProfileAvatar() {
        ProfileImageService.shared.clearAvatar()
    }
    
    private func clearPhotos() {
        ImagesListService.shared.clearPhotos()
    }
    
    private func clearToken() {
        OAuth2TokenStorage.shared.token = nil
    }
}

