//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 20.02.2024.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    private init() {}
    
    private (set) var photos: [Photo] = []
    private var isFetching = false

    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard !isFetching else {
            completion(.failure(NSError(domain: "ImagesListService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Already fetching"])))
            return
        }
        
        isFetching = true
    
        guard let token = oauth2TokenStorage.token else {
            completion(.failure(NSError(domain: "ImagesListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
            return
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        let request = nextPageRequest(token: token, page: nextPage)
        
        let task = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            defer {
                self.isFetching = false
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "ImagesListService", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let newPhotos = try JSONDecoder().decode([Photo].self, from: data)
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                completion(.success(newPhotos))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

struct Photo: Codable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

// MARK: - Methods
private extension ImagesListService {
    func nextPageRequest(token: String, page: Int) -> URLRequest {
        guard let url = URL(string: "\(Constants.defaultBaseImagesURL)/me?page=\(page)") else {
            fatalError("Failed to create URL")
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
