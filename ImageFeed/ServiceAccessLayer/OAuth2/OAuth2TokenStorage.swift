//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 30.01.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "OAuth2AccessToken"
    
    private let storage = UserDefaults.standard
    
    var token: String? {
        get {
            return storage.string(forKey: tokenKey)
        }
        set {
            storage.set(newValue, forKey: tokenKey)
        }
    }
}
