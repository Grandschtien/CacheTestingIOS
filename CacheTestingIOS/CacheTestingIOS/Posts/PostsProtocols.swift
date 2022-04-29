//
//  PostsProtocols.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 22.04.2022.
//  
//

import Foundation

protocol PostsModuleInput {
	var moduleOutput: PostsModuleOutput? { get }
}

protocol PostsModuleOutput: AnyObject {
}

protocol PostsViewInput: AnyObject {
    func didMadeViewModels(_ viewModels: [PostViewModel])
}

protocol PostsViewOutput: AnyObject {
    func viewDidLoad()
    func didTapOnPost(withId id: Int)
}

protocol PostsInteractorInput: AnyObject {
    func loadPosts()
}

protocol PostsInteractorOutput: AnyObject {
    func didLoadPosts(_ posts: [Post])
}

protocol PostsRouterInput: AnyObject {
    func routeToCommentsToPost(withId id: Int)
}
