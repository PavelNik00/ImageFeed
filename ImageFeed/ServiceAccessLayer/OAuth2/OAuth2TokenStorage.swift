//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 30.01.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
//    private let tokenKey = "OAuth2AccessToken"
    
//    private let storage = UserDefaults.standard
    
    static let shared = OAuth2TokenStorage()
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: Constants.bearerToken)
        }
        set {
            guard let newValue = newValue else { return }
            keychainWrapper.set(newValue, forKey: Constants.bearerToken)
        }
    }
}
