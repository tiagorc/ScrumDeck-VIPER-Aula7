//
//  Coordinator.swift
//  ScrumDeck - Aula 7
//
//  Created by Euler Carvalho on 14/06/21.
//

import UIKit

class Coordinator {
    private var window: UIWindow
    private var navigationController: UINavigationController
    
    private var sprintRouter: SprintRouter?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        
        self.window.rootViewController = navigationController
        
        self.window.makeKeyAndVisible()
        sprintRouter = SprintRouter()
    }
    
    func start() {
        coordinate(to: sprintRouter)
    }
    
    func coordinate(to router: BaseRouter?) {
        guard router != nil else { return }
        
        router?.start(self.navigationController)
    }
}
