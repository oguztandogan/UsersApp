//
//  UsersListViewController.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Combine
import Foundation
import UIKit

class UsersListViewController: UIViewController {
    var viewModel: UsersListViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private lazy var usersTableView: UsersTableView = {
        let tableView = UsersTableView(configuration: .default)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "UsersTableView"
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.onAppear()
        navigationItem.title = "Users"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    private func setupUI() {
        view.backgroundColor = .appBackground
        view.accessibilityIdentifier = "UsersListViewController"
        view.addSubview(usersTableView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            usersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                guard let self = self else { return }
                let cellDataArray = self.viewModel.createCellDataArray()
                self.usersTableView.updateUsers(with: users, cellDataArray: cellDataArray)
            }
            .store(in: &cancellables)
    }
}

extension UsersListViewController: UsersTableViewDelegate {
    func didSelectUser(_ user: UserEntity) {
        viewModel.navigateToUserDetails(for: user)
    }

    func didTapFavoriteButton(for user: UserEntity) {
        viewModel.favouriteButtonAction(for: user)
    }

    func shouldLoadMoreData(currentCount _: Int) {
        viewModel.fetchUsers(isPagination: true, isRefreshing: false)
    }

    func didPullToRefresh() {
        viewModel.fetchUsers(isPagination: false, isRefreshing: true)
    }
}
