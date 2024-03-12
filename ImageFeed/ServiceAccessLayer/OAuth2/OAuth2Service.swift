//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 30.01.2024.
//

import Foundation

final class OAuth2Service {
    
    // MARK: - Properties
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private let tokenStorage = OAuth2TokenStorage()
    
    private (set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    
    // MARK: - Func
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        print("Error: OAuth2Service encountered an invalid request - repeated code.")
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else {
            print("Error: Failed to make request with code \(code).")
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (
            result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                print("Error: OAuth2Service encountered an error - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

// MARK: - Extensions
extension OAuth2Service {
    func authTokenRequest(code: String) -> URLRequest? {
        
        let params = AuthConfiguration.standart
        
        return URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(params.accessKey)"
            + "&&client_secret=\(params.secretKey)"
            + "&&redirect_uri=\(params.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
    
    private func makeRequest(code: String) -> URLRequest? {
        if let url = URL(string: "...\(code)") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            return request
        } else {
            print("Failed to create URL")
            return nil
        }
    }
}


