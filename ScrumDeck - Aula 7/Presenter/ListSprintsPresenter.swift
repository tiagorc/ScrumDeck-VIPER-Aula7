//
//  ListSprintsPresenter.swift
//  ScrumDeck - Aula 7
//
//  Created by Euler Carvalho on 14/06/21.
//

import Foundation
import RxCocoa

protocol ListSprintsPresenterToView: AnyObject {
    var sprints: BehaviorRelay<[Sprint]?> { get }
    var sprint: BehaviorRelay<Sprint?> { get }
    func getSprints()
    func getSprint(by id: Int)
    func deleteSprint(by id: Int)
    func createSprint(with title: String, link: String?)
}

class ListSprintsPresenter {
    
    weak var viewToPresenter: ListSprintsPresenterToView?
    var interactorOutput: ListSprintsInteractorToPresenter?
    
    var interactor: ListSprintsInteractor?
    var view: ListSprintsViewToPresenter?
    
    private(set) var sprints = BehaviorRelay<[Sprint]?>(value: nil)
    private(set) var sprint = BehaviorRelay<Sprint?>(value: nil)
}

extension ListSprintsPresenter: ListSprintsPresenterToView {
    
    func getSprints() {
        view?.setLoading(true)
        interactor?.getSprints()
    }
    
    func getSprint(by id: Int) {
        view?.setLoading(true)
        interactor?.getSprint(by: id)
    }
    
    func deleteSprint(by id: Int) {
        view?.setLoading(true)
        interactor?.deleteSprint(by: id)
    }
    
    func createSprint(with title: String, link: String?) {
        view?.setLoading(true)
        interactor?.createSprint(with: title, link: link)
    }
}

extension ListSprintsPresenter: ListSprintsInteractorToPresenter {
    
    func listSprints(sprints: [Sprint]) {
        view?.setLoading(false)
        self.sprints.accept(sprints)
    }
    
    func showSprint(sprint: Sprint) {
        view?.setLoading(false)
        self.sprint.accept(sprint)
    }
    
    func sprintWasDeleted() {
        getSprints()
    }
    
    func sprintWasCreated(_ sprint: Sprint) {
        view?.setLoading(false)
        var update = self.sprints.value
        update?.insert(sprint, at: .zero)
        self.sprints.accept(update)
    }
    
    func processError(error: Error?) {
        view?.setLoading(false)
    }
}
