//
//  Router.swift
//  ScrumDeck - Aula 7
//
//  Created by Euler Carvalho on 14/06/21.
//

import UIKit

class SprintRouter: BaseRouter {
    
    let view = UIView(frame: UIScreen.main.bounds)
    let viewController = ListSprintsViewController(nibName: "ListSprintsViewController", bundle: .main)
    let presenter = ListSprintsPresenter()
    let interactor = ListSprintsInteractor()
    
    override init() {
        super.init()

        setupModule()
    }
    
    override func start(_ navigationController: UINavigationController) {
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        super.push(viewController: viewController, on: navigationController)
    }
    
    private func setupModule() {
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.output = presenter
    }
    
}
