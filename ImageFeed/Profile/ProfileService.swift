//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 06.02.2024.
//

import Foundation

final class ProfileService {
    
    // MARK: - Public Properties
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    private(set) var profile: Profile?
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if profile != nil { return }
        task?.cancel()
        
        let request = profileRequest(token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (
            result: Result<ProfileResult,Error>
        ) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let profile = Profile(callData: body)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func clearProfile() {
        profile = nil
    }
}

// MARK: - Methods
private extension ProfileService {
    func profileRequest(token: String) -> URLRequest {
        guard let url = URL(
            string: "\(Constants.defaultBaseURL)"
            + "/me")
        else {
            fatalError("Failed to create URL")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
