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
    //    private let urlSession = URLSession.shared
    //    private let storage = UserDefaults.standard
    private let urlSession = URLSession.shared
    //    private let storage: OAuth2TokenStorage
    
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
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result:
        Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

//    func fetchOAuthBody(request: URLRequest, completion: @escaping
//                        (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
//        let fulfillCompletionOnMainThread: (Result<OAuthTokenResponseBody, Error>) -> Void =
//        { result in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//        
//        let session = URLSession.shared
//        let task = session.dataTask(with: request, completionHandler: { data, response,
//            error in
//            if let data = data, let response = response, let statusCode = (response as?
//                                                                           HTTPURLResponse)?.statusCode {
//                if 200..<300 ~= statusCode {
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(OAuthTokenResponseBody.self, from: data)
//                        fulfillCompletionOnMainThread(.success(result))
//                    } catch {
//                        fulfillCompletionOnMainThread(.failure(NetworkError.decodingError(error)))
//                    }
//                } else {
//                    fulfillCompletionOnMainThread(.failure(NetworkError
//                        .httpStatusCode(statusCode )))
//                }
//            } else if let error = error {
//                fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
//            } else {
//                fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
//            }
//        })
//        task.resume()
//        return task
//    }
    //        assert(Thread.isMainThread)
    //        if task != nil {
    //            if lastCode != code {
    //                task?.cancel()
    //            } else {
    //                return
    //            }
    //        } else {
    //            if lastCode == code {
    //                return
    //            }
    //        }
    //        lastCode = code
    //        let request = authTokenRequest(code: code)
    //        let task = object(for: request) { [weak self] result in
    //            guard let self = self else { return }
    //            DispatchQueue.main.async {
    //                switch result {
    //                case .success(let body):
    //                    let authToken = body.accessToken
    //                    self.authToken = authToken
    //                    completion(.success(authToken))
    //                case .failure(let error):
    ////                    completion(.failure(error))
    //                    self.lastCode = nil
    //                }
    //                self.task = nil
    ////                if result != nil {
    ////                    self.lastCode = nil
    ////                }
    //            }
    //        }
    //        self.task = task
    //        task.resume()
    //    }
    //
    //    private func makeRequest(code: String) -> URLRequest {
    //        guard let url = URL(string: "...\(code)") else { fatalError("Failed to create URL") }
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //        return request
    //    }
    //
    //    private init() { }
    //}
    
    // MARK: - Extensions
    extension OAuth2Service {
        private func object(
            for request: URLRequest,
            completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
        ) -> URLSessionTask {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return urlSession.data(for: request) { (result: Result<Data, Error>) in
                let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                    Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
                }
                completion(response)
            }
        }
        
        func authTokenRequest(code: String) -> URLRequest? {
            URLRequest.makeHTTPRequest(
                path: "/oauth/token"
                + "?client_id=\(Constants.accessKey)"
                + "&&client_secret=\(Constants.secretKey)"
                + "&&redirect_uri=\(Constants.redirectURI)"
                + "&&code=\(code)"
                + "&&grant_type=authorization_code",
                httpMethod: "POST",
                baseURL: URL(string: "https://unsplash.com")!
            )
        }
        
        //    private struct OAuthTokenResponseBody: Decodable {
        //        let accessToken: String
        //        let tokenType: String
        //        let scope: String
        //        let createdAt: Int?
        //    }
    }
    
    
    //// MARK: - Network Connection
    //enum NetworkError: Error {
    //    case httpStatusCode(Int)
    //    case urlRequestError(Error)
    //    case urlSessionError
    //}
    
    //extension URLSession {
    //    func data(
    //        for request: URLRequest,
    //        completion: @escaping (Result<Data, Error>) -> Void
    //    ) -> URLSessionTask {
    //        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
    //            DispatchQueue.main.async {
    //                completion(result)
    //            }
    //        }
    //        let task = dataTask(with: request, completionHandler: { data, response, error in
    //            if let data = data,
    //               let response = response,
    //               let statusCode = (response as? HTTPURLResponse)?.statusCode
    //            {
    //                if 200 ..< 300 ~= statusCode {
    //                    fulfillCompletion(.success(data))
    //                } else {
    //                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
    //                }
    //            } else if let error = error {
    //                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
    //            } else {
    //                fulfillCompletion(.failure(NetworkError.urlSessionError))
    //            }
    //        })
    //        task.resume()
    //        return task
    //    }
    //}

