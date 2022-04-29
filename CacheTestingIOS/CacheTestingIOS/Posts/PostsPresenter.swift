//
//  PostsPresenter.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 22.04.2022.
//  
//

import Foundation

final class PostsPresenter {
	weak var view: PostsViewInput?
    weak var moduleOutput: PostsModuleOutput?
    
	private let router: PostsRouterInput
	private let interactor: PostsInteractorInput
    
    init(router: PostsRouterInput, interactor: PostsInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
    
    private func makeViewModels(posts: [Post]) -> [PostViewModel] {
        return posts.map { post in
            return PostViewModel(
                userId: post.userId,
                id: post.id,
                title: post.title,
                body: post.body
            )
        }
    }
}

extension PostsPresenter: PostsModuleInput {
}

extension PostsPresenter: PostsViewOutput {
    func viewDidLoad() {
        interactor.loadPosts()
    }
    
    func didTapOnPost(withId id: Int) {
        router.routeToCommentsToPost(withId: id)
    }
}

extension PostsPresenter: PostsInteractorOutput {
    func didLoadPosts(_ posts: [Post]) {
       let viewModels = makeViewModels(posts: posts)
        view?.didMadeViewModels(viewModels)
    }
}
