//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 13.02.2024.
//

import Foundation

protocol AlertModelProtocol {
    var title: String { get }
    var message: String { get }
    var buttonText: String { get }
    var completion: (Bool) -> Void { get }
}

struct AlertModel: AlertModelProtocol {
    let title: String
    let message: String
    let buttonText: String
    let completion: (Bool) -> Void
}

struct AlertModelRepeat: AlertModelProtocol {
    let title: String
    let message: String
    let buttonText: String
    let cancelButtonText: String
    let completion: (Bool) -> Void
}
