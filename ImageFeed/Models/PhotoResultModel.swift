//
//  PhotoResultModel.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 20.02.2024.
//

import Foundation

// Структура предоставляющая информацию о фото
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

// Структура для декодирования JSON-ответа с информацией о фото
struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let isLikedByUser: Bool
    let description: String
    let urls: UrlsResult
    
    // Определение ключей для декодирования
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case isLikedByUser = "liked_by_user"
        case description
        case urls
    }
}

// Структура для декодирования JSON-ответа URL-ами
struct UrlsResult: Codable {
    let full: String
    let thumb: String
}
