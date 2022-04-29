//
//  PostsInteractor.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 22.04.2022.
//  
//

import Foundation
import Combine

final class PostsInteractor {
    weak var output: PostsInteractorOutput?
    private var subscriptions: Set<AnyCancellable> = []
    private let networkManager: NetworkManager
    private let cacheManager = Cache<CacheKeys, [Post]>()
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    enum CacheKeys: String, Codable {
        case posts
    }
}

extension PostsInteractor: PostsInteractorInput {
    func loadPosts() {
        if let posts = cacheManager.value(forKey: .posts) {
            self.output?.didLoadPosts(posts)
        } else if let cache = try? cacheManager.readFromDisk(withName: CacheKeys.posts.rawValue),
                  let posts = cache.value(forKey: .posts)
        {
            self.output?.didLoadPosts(posts)
        }
        
        else {
            networkManager.fetchPosts()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { [unowned self] posts in
                    self.cacheManager.insert(posts, forKey: .posts)
                    do  {
                        try self.cacheManager.saveToDisk(withName: CacheKeys.posts.rawValue)
                    } catch {
                        print("Error")
                    }
                    self.output?.didLoadPosts(posts)
                }
                .store(in: &subscriptions)
        }
    }
}
