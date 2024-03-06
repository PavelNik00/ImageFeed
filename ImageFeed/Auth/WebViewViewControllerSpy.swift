//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 06.03.2024.
//

import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
//    var view: WebViewViewControllerProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
//    
////    func viewDidLoad() {
////        loadRequestCalled = true
////    }
//    
//    func didUpdateProgressValue(_ newValue: Double) {
//        
//    }
//    
//    func code(from url: URL) -> String? {
//        return nil
//    }
}
