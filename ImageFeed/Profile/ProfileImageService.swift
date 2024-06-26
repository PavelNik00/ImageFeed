//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 13.02.2024.
//

import Foundation

final class ProfileImageService {
    
    //MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    //MARK: - Private Properties
    private (set) var avatarUrl: String?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ){
        assert(Thread.isMainThread)
        if avatarUrl != nil { return }
        task?.cancel()
        
        guard let token = oauth2TokenStorage.token else { return }
        let request = profileImageRequest(token: token, username: username)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userResult):
                let avatarUrl = userResult.profileImage.large
                self.avatarUrl = avatarUrl
                completion(.success(avatarUrl))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarUrl])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func clearAvatar() {
        avatarUrl = nil
    }
}

// MARK: - Public Methods
private extension ProfileImageService {
    private func profileImageRequest(token: String, username: String) -> URLRequest {
        guard let url = URL(
            string: "\(Constants.defaultBaseURL)" + "/users/" + username)
        else {
            fatalError("Failed to create URL")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
