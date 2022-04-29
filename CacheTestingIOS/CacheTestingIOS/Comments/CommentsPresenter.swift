//
//  CommentsPresenter.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 25.04.2022.
//  
//

import Foundation

final class CommentsPresenter {
	weak var view: CommentsViewInput?
    weak var moduleOutput: CommentsModuleOutput?
    
	private let router: CommentsRouterInput
	private let interactor: CommentsInteractorInput
    
    init(router: CommentsRouterInput, interactor: CommentsInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
    
    private func makeViewModels(fromComments comments: [Comment]) -> [CommentViewModel] {
        return comments.map { comment in
            return CommentViewModel(postId: comment.postId,
                                    id: comment.id,
                                    name: comment.name,
                                    email: comment.email,
                                    body: comment.body)
        }
    }
}

extension CommentsPresenter: CommentsModuleInput {
    func recivePostId(id: Int) {
        interactor.fetchCommentsForPost(withId: id)
    }
    
}

extension CommentsPresenter: CommentsViewOutput {
    func viewDidLoad() {
        
    }
    
}

extension CommentsPresenter: CommentsInteractorOutput {
    func didLoadComments(_ comments: [Comment]) {
        let viewModels = makeViewModels(fromComments: comments)
        view?.didMadeViewModels(viewModels)
    }
}
