//
//  CommentsProtocols.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 25.04.2022.
//  
//

import Foundation

protocol CommentsModuleInput {
	var moduleOutput: CommentsModuleOutput? { get }
    func recivePostId(id: Int)
}

protocol CommentsModuleOutput: AnyObject {
}

protocol CommentsViewInput: AnyObject {
    func didMadeViewModels(_ viewModels: [CommentViewModel])
}

protocol CommentsViewOutput: AnyObject {
    func viewDidLoad()
}

protocol CommentsInteractorInput: AnyObject {
    func fetchCommentsForPost(withId id: Int)
}

protocol CommentsInteractorOutput: AnyObject {
    func didLoadComments(_ comments: [Comment])
}

protocol CommentsRouterInput: AnyObject {
}
