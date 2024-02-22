//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 20.02.2024.
//

import Foundation

// Класс для обработки запросов к Unsplash API
final class ImagesListService {
    
    static let shared = ImagesListService()
    
    internal init() {}
    // Массив для хранения загруженных фото
    private (set) var photos: [Photo] = []
    // Форматтер для преобразования дат
    private let dateFormatter = ISO8601DateFormatter()
    // Номер последней загруженной страницы
    private var lastLoadedPage: Int?
    // Объект для выполнения сетевых запросов
    private let urlSession = URLSession.shared
    // Хранилище токена OAuth2
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    // Текущая задача
    private var task: URLSessionTask?
    
    // Статическое свойство для уведомления об изменении состояния
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // Метод для загрузки следующей странице фото
    func fetchPhotosNextPage() {
        // Проверка что метод вызывается из главного потока
        assert(Thread.isMainThread)
        // Проверка что не выполняется уже другая задача
        if task != nil { return }
        
        // Вычисление номера следующей страницы
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        // Обновление номера последней загруженной страницы
        lastLoadedPage = nextPage

        // Вызов расширения для выполнения запроса URL
        let request = nextPageRequest(nextPage: nextPage)
        
        // Создание задачи для выполнения запроса
        let task = urlSession.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResultList):
                
                // Обработка успешного результата
                for photoResult in photoResultList {
                    
                    // Преобразование данных из photoResult в photo
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
                    
                    // Добавление фото в массив
                    self.photos.append(photo)
                }
                
                // Отправка уведомлений об изменении состояния
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
                
                // Очистка текущей задачи
                self.task = nil
                
            case .failure(let error):
                // Обработка ошибки
                print("Failed with error: \(error)")
                // Очистка текущей задачи
                self.task = nil
            }
        }
        
        // Установка текущей задачи
        self.task = task
        // Запуск задачи
        task.resume()
    }
}

// MARK: - Methods
private extension ImagesListService {
    func nextPageRequest(nextPage: Int) -> URLRequest {
        
        // URL для запроса
        let imageListURL = Constants.defaultBaseURL.absoluteString + "/photos"
        var urlComponents = URLComponents(string: imageListURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
        ]
        
        // Построение конечного URL для запроса
        guard let finalUrl = urlComponents?.url else { fatalError("Failed to create URL from components") }
        // Создание запроса
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "GET"
        
        // Получение токена и добавление его к заголовку
        guard let bearerToken = oauth2TokenStorage.token else { fatalError("OAuth token is missing") }
        // Установка заголовка с токеном
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // задаем функцию для изменения лайка к фото с заданным индикатором
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        // строка для формирования пути запроса к API для изменения лайка
        let path = "photos/\(photoId)/like"
        
        // определение HTTP-метода в зависимости от того, ставим лайк или убираем
        let httpMethod = isLike ? "POST" : "DELETE"
        
        // создание базового объекта URLRequest с использованием расширения makeHTTPRequest
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: httpMethod)
        
        // получаем токен доступа OAth2 из хранилища
        guard let bearerToken = oauth2TokenStorage.token else { return }
        
        // устанавливаем токен в заголовок запроса для авторизации
        request.setValue("bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        // выполняем асинхронный запрос к API для изменения статуса лайка
        let task = urlSession.data(for: request) { result in
            switch result {
            case .success:
                // при успешном запросе обновляем статус лайка в массиве photos
                // поиск индекса элемента
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    // текущий элемент
                    let photo = self.photos[index]
                    // копия элемента с инвертированным значением isLiked
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked) // инвертируем статус лайка
                    // заменяем элемент в массиве
                    self.photos[index] = newPhoto
                }
                // возвращаем успешное завершение с пустым запросом
                let voidReturn: Void = ()
                completion(.success(voidReturn))
                
            case .failure(let error):
                // возвращаем ошибку при ошибке :)
                completion(.failure(error))
            }
        }
        
        // тут запускаем выполнение задачи
        task.resume()
    }
}
