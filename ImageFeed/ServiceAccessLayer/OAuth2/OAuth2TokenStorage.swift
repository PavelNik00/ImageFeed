//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 30.01.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {

    static let shared = OAuth2TokenStorage()
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: Constants.bearerToken)
        }
        set {
            if let newValue = newValue {
                keychainWrapper.set(newValue, forKey: Constants.bearerToken)
            } else {
                keychainWrapper.removeObject(forKey: Constants.bearerToken)
            }
        }
    }
}
