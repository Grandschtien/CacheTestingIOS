//
//  PostsRouter.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 22.04.2022.
//  
//

import UIKit

final class PostsRouter {
    var viewController: UIViewController?
}

extension PostsRouter: PostsRouterInput {
    func routeToCommentsToPost(withId id: Int) {
        let commentsContext = CommentsContext(moduleOutput: nil)
        let commentsContainer = CommentsContainer.assemble(with: commentsContext)
        commentsContainer.input.recivePostId(id: id)
        viewController?.navigationController?.pushViewController(commentsContainer.viewController,
                                                                 animated: true)
    }
}
