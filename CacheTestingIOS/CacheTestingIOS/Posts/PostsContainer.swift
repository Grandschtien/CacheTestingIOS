//
//  PostsContainer.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 22.04.2022.
//  
//

import UIKit

final class PostsContainer {
    let input: PostsModuleInput
	let viewController: UIViewController
	private(set) weak var router: PostsRouterInput!

	static func assemble(with context: PostsContext) -> PostsContainer {
        let router = PostsRouter()
        let networkManager = NetworkManager()
        let interactor = PostsInteractor(networkManager: networkManager)
        let presenter = PostsPresenter(router: router, interactor: interactor)
		let viewController = PostsViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput
        router.viewController = viewController
		interactor.output = presenter

        return PostsContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: PostsModuleInput, router: PostsRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct PostsContext {
	weak var moduleOutput: PostsModuleOutput?
}
