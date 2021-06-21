//
//  ListSprintsInteractor.swift
//  ScrumDeck - Aula 7
//
//  Created by Euler Carvalho on 14/06/21.
//

import UIKit
import RxSwift

protocol ListSprintsInteractorToPresenter: AnyObject {
    func listSprints(sprints: [Sprint])
    func showSprint(sprint: Sprint)
    func processError(error: Error?)
    func sprintWasDeleted()
    func sprintWasCreated(_ sprint: Sprint)
}

extension ListSprintsInteractorToPresenter {
    func processError(error: Error?) {}
}

protocol ListSprintsInteractorInput: AnyObject {
    func getSprints()
    func getSprint(by id: Int)
    func deleteSprint(by id: Int)
}

class ListSprintsInteractor {
    
    weak var output: ListSprintsInteractorToPresenter?
    
    let disposeBag = DisposeBag()

}

extension ListSprintsInteractor: ListSprintsInteractorInput {
    func getSprints() {
        SprintDAO.getSprints()
            .subscribe {[weak self] result in
                guard let sprints = result.element else {
                    self?.output?.processError(error: NSError() as Error)
                    return
                }
                
                self?.output?.listSprints(sprints: sprints)
            }.disposed(by: disposeBag)
    }
    
    func getSprint(by id: Int) {
        SprintDAO.getSprint(by: id)
            .subscribe { [weak self] result in
                guard let sprint = result.element else {
                    self?.output?.processError(error: NSError() as Error)
                    return
                }
                
                self?.output?.showSprint(sprint: sprint)
            }.disposed(by: disposeBag)
    }
    
    func deleteSprint(by id: Int) {
        SprintDAO.deleteSprint(by: id)
            .subscribe { [weak self] result in
                guard let _ = result.element else {
                    self?.output?.processError(error: NSError() as Error)
                    return
                }
                
                self?.output?.sprintWasDeleted()
            }.disposed(by: disposeBag)
    }
    
    func createSprint(with title: String, link: String?) {
        SprintDAO.createSprint(with: title, link: link)
            .subscribe{ [weak self] result in
                guard let sprint = result.element as? Sprint else {
                    self?.output?.processError(error: NSError() as Error)
                    return
                }
                self?.output?.sprintWasCreated(sprint)
            }.disposed(by: disposeBag)
    }
}
