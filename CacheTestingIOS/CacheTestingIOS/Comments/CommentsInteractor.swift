//
//  CommentsInteractor.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 25.04.2022.
//  
//

import Foundation
import Combine

final class CommentsInteractor {
	weak var output: CommentsInteractorOutput?
    var networkManager: NetworkManager?
    private var subscriptions: Set<AnyCancellable> = []
    private let cacheManager = Cache<CacheKeys, [Comment]>()
    enum CacheKeys: String {
        case comments
    }
}

extension CommentsInteractor: CommentsInteractorInput {
    func fetchCommentsForPost(withId id: Int) {
        if let comments = cacheManager.value(forKey: .comments) {
            output?.didLoadComments(comments)
        } else {
            networkManager?.fetchCommentsForPost(withId: id)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished :break
                    case .failure(let error): print(error.localizedDescription)
                    }
                }, receiveValue: {[weak self] comments in
                    self?.cacheManager.insert(comments, forKey: .comments)
                    self?.output?.didLoadComments(comments)
                })
                .store(in: &subscriptions)
        }
    }
}
