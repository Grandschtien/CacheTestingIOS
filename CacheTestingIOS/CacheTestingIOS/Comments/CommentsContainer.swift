//
//  CommentsContainer.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 25.04.2022.
//  
//

import UIKit

final class CommentsContainer {
    let input: CommentsModuleInput
	let viewController: UIViewController
	private(set) weak var router: CommentsRouterInput!

	static func assemble(with context: CommentsContext) -> CommentsContainer {
        let router = CommentsRouter()
        let networkManager = NetworkManager()
        let interactor = CommentsInteractor()
        let presenter = CommentsPresenter(router: router, interactor: interactor)
		let viewController = CommentsViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput
        interactor.networkManager = networkManager
		interactor.output = presenter

        return CommentsContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: CommentsModuleInput, router: CommentsRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct CommentsContext {
	weak var moduleOutput: CommentsModuleOutput?
}

