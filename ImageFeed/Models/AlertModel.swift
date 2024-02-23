//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 13.02.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}

struct AlertModelRepeat {
    let title: String
    let message: String
    let buttonText: String
    let cancelButtonText: String
    let completion: () -> Void
}
