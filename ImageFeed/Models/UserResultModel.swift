//
//  UserResultModel.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 13.02.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
