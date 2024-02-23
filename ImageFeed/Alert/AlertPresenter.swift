//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 13.02.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol, AlertPresenterRepeatProtocol {
    
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showError(for model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()
            }
        alert.addAction(action)
        
        delegate?.present(alert, animated: true)
    }
    
    func showError(for model: AlertModelRepeat) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()
            }
        
        let actionCancel = UIAlertAction(
            title: model.cancelButtonText,
            style: .default) { _ in
                model.completion()
            }
        
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        delegate?.present(alert, animated: true)
    }
}
