//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 23.02.2024.
//

import Foundation
// Обязательный импорт
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        clearProfile()
        clearProfileAvatar()
        clearPhotos()
        clearToken()
        
        // Переход на начальный экран после логаута
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.showInitialScreen()
        }
    }
    
    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func clearProfile() {
        // Вызываем метод очистки профиля из ProfileService
        ProfileService.shared.clearProfile()
    }
    
    private func clearProfileAvatar() {
        // Вызываем метод очистки аватарки
        ProfileImageService.shared.clearAvatar()
    }

    private func clearPhotos() {
        // Вызываем метод очистки фото
        ImagesListService.shared.clearPhotos()
    }
    
    private func clearToken() {
        // Вызываем метод очистки токена
        OAuth2TokenStorage.shared.token = nil
    }

}
    
