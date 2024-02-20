//
//  ProfileImageModel.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 13.02.2024.
//

import Foundation

struct ProfileImage: Codable {
    let smallImage: [String:String]
    
    init(callData: UserResult) {
        self.smallImage = callData.profileImage
    }
}
