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
    
    // MARK: Storage contants
    static let bearerToken = "bearerToken"
}
