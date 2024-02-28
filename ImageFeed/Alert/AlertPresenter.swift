//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 13.02.2024.
//

import UIKit

final class AlertPresenter {
    
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    static func showAlert(for model: AlertModelProtocol, in viewController: UIViewController) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default
        ) { _ in
            model.completion(true)
        }
        alert.addAction(action)
        
        if let modelRepeat = model as? AlertModelRepeat {
            let actionCancel = UIAlertAction(
                title: modelRepeat.cancelButtonText,
                style: .default
            ) { _ in
                modelRepeat.completion(false)
            }
            alert.addAction(actionCancel)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
