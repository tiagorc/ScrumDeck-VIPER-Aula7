//
//  ListSprintsViewController.swift
//  ScrumDeck - Aula 7
//
//  Created by Euler Carvalho on 14/06/21.
//

import UIKit
import RxSwift
import RxSwiftExt

protocol ListSprintsViewToPresenter: AnyObject {
    func setLoading(_ loading: Bool)
}

class ListSprintsViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: ListSprintsPresenterToView?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sprints"
        setupTableView()
        bindPresenter()
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.registerCell(type: ListSprintsTableViewCell.self)
    }
    
    private func bindPresenter() {
        presenter?.sprints
            .observe(on: MainScheduler())
            .bind { [weak self] _ in
                self?.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        presenter?.sprint
            .observe(on: MainScheduler())
            .bind { [weak self] _ in
                self?.showAlertSprint()
            }.disposed(by: disposeBag)
        
        presenter?.getSprints()
    }
    
    private func showAlertSprint() {
        guard let sprint = presenter?.sprint.value else { return }
        let alert = UIAlertController(
            title: "Detalhes Sprint",
            message: "Id: \(sprint.id) \nNome: \(sprint.nome)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func confirmDeleteSprint(with id: Int) {
        let alert = UIAlertController(
            title: "Apagar Sprint",
            message: "Tem certeza que deseja apagar essa Sprint?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(
            title: "Apagar",
            style: .destructive) { [weak self] _ in
            self?.presenter?.deleteSprint(by: id)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension ListSprintsViewController: ListSprintsViewToPresenter {
    func setLoading(_ loading: Bool) {
        loading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    }
}

extension ListSprintsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.sprints.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(withType: ListSprintsTableViewCell.self, for: indexPath) as ListSprintsTableViewCell
        
        if let sprint = presenter?.sprints.value?[indexPath.row] {
            cell.bind(sprint: sprint)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = presenter?.sprints.value?[indexPath.row].id else { return }
        presenter?.getSprint(by: id)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            if let id = self?.presenter?.sprints.value?[indexPath.row].id {
                self?.confirmDeleteSprint(with: id)
                completion(true)
            }
        }
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
