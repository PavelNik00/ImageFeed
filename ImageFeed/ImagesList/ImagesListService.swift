//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 20.02.2024.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    internal init() {}
    private (set) var photos: [Photo] = []
    private let dateFormatter = ISO8601DateFormatter()
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = nextPage

        let request = nextPageRequest(nextPage: nextPage)
        
        let task = urlSession.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResultList):
                for photoResult in photoResultList {
                    let photoSize = CGSize(width: Double(photoResult.width),
                                           height: Double(photoResult.height))
                    
                    var photoCreatedDate: Date?
                    if let parsedDate = photoResult.createdAt {
                        photoCreatedDate = self.dateFormatter.date(from: parsedDate)
                    }
                    
                    let photo = Photo(
                        id: photoResult.id,
                        size: photoSize,
                        createdAt: photoCreatedDate,
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.full,
                        isLiked: photoResult.isLikedByUser)
                    
                    self.photos.append(photo)
                }
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
                
                self.task = nil
                
            case .failure(let error):
                print("Failed with error: \(error)")
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    func clearPhotos() {
        photos = []
        lastLoadedPage = nil
    }
}

// MARK: - Methods
private extension ImagesListService {
    func nextPageRequest(nextPage: Int) -> URLRequest {
        let imageListURL = Constants.defaultBaseURL.absoluteString + "/photos"
        var urlComponents = URLComponents(string: imageListURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
        ]
        guard let finalUrl = urlComponents?.url else { fatalError("Failed to create URL from components") }
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "GET"
        
        guard let bearerToken = oauth2TokenStorage.token else { fatalError("OAuth token is missing") }
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension ImagesListService {
    func changeLike(photoId: String,
                    isLike: Bool,
                    _ completion: @escaping (Result<Void, Error>) -> Void) {
        let path = "photos/\(photoId)/like"
        let httpMethod = isLike ? "POST" : "DELETE"
        
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: httpMethod)
        guard let bearerToken = oauth2TokenStorage.token else { return }
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        let task = urlSession.data(for: request) { result in
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked)
                    self.photos[index] = newPhoto
                }
                let voidReturn: Void = ()
                completion(.success(voidReturn))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
