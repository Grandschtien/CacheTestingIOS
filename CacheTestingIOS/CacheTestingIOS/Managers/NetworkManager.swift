//
//  NetworkManager.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 22.04.2022.
//

import Foundation
import Combine

final class NetworkManager {
    
    private var baseUrl: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "jsonplaceholder.typicode.com"
        return urlComponents
    }
    
    private enum UrlPaths: String {
        case posts = "/posts/"
        case comments = "/comments"
    }
    
    private let commentsUrlString = "https://jsonplaceholder.typicode.com/comments"
    
    func fetchPosts() -> AnyPublisher<[Post], NetworkError> {
        var baseUrl = baseUrl
        baseUrl.path = UrlPaths.posts.rawValue
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: baseUrl.url!)
        return session.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw NetworkError.statusCode
                }
                return response.data
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .mapError {NetworkError.map($0)}
            .eraseToAnyPublisher()
    }
    
    func fetchCommentsForPost(withId id: Int) -> AnyPublisher<[Comment], NetworkError> {
        var baseUrl = baseUrl
        baseUrl.path = UrlPaths.comments.rawValue
        baseUrl.queryItems = [URLQueryItem(name: "postId", value: "\(id)")]
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: baseUrl.url!)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw NetworkError.statusCode
                }
                return response.data
            }
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .mapError {NetworkError.map($0)}
            .eraseToAnyPublisher()
        
    }
    
}
extension NetworkManager {
    enum NetworkError: Error {
        case statusCode
        case decoding
        case invalidURL
        case other(Error)
        
        static func map(_ error: Error) -> NetworkError {
            return (error as? NetworkError) ?? .other(error)
        }
    }
}
