//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 13.02.2024.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showError(for model: AlertModel)
}
