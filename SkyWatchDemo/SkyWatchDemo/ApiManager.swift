//
//  ApiManager.swift
//  SkyWatchDemo
//
//  Created by BruceWu on 2022/7/7.
//

import Foundation
import UIKit

let apiUrl = "https://jsonplaceholder.typicode.com/"

enum ApiPath: String {
    case users = "users/"
    case albums = "albums/"
    case photos = "photos/"
}

class ApiManager {
    
    typealias Success = (Data) -> ()
    typealias Failure = (Error) -> ()
    
    static let instance = ApiManager()
    
    let imageCache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func get(path: ApiPath, parameters: String = "", success: @escaping Success, failute: @escaping Failure) {
        let urlString = apiUrl + path.rawValue + parameters
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, resp, err in
                if err != nil {
                    failute(err!)
                    return
                }
                guard let data = data else { return }
                success(data)
            }
            task.resume()
        }
    }
    
    func fetchImage(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        if let image = imageCache.object(forKey: url as NSURL) {
            completionHandler(image)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url as NSURL)
                completionHandler(image)
            } else {
                completionHandler(nil)
            }
        }.resume()
    }
    
}
