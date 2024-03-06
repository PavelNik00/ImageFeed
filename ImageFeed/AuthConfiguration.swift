//
//  Constants.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 18.01.2024.
//

import UIKit

enum Constants {
    // MARK: Unsplash api constants
    static let accessKey = "9yYyoxsM08bps-2uFhkfBdTEZmwYp3YErtVt-N2wVxg"
    static let secretKey = "6cClc75p2bFawoFjs8J9fn8gqXii8RNIbkqSWQvo8Oc"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    // MARK: Unsplash api base paths
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
//    static let defaultBaseImagesURL = URL(string: "https://api.unsplash.com/photos?page=1")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    // MARK: Storage contants
    static let bearerToken = "bearerToken"
}

struct AuthConfiguration {
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessKey,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
