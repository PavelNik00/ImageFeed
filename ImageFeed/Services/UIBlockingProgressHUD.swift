//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 06.02.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
        ProgressHUD.animationType = .squareCircuitSnake
        ProgressHUD.colorAnimation = .systemBlue
        ProgressHUD.colorProgress = .systemBlue
        ProgressHUD.colorBackground = .ypBlack
        ProgressHUD.colorHUD = .ypBlack
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
