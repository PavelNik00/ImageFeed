//
//  UserResultModel.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 13.02.2024.
//

import Foundation

struct ImagesSize: Codable {
    let large: String
}

struct UserResult: Codable {
    let profileImage: ImagesSize
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
