//
//  BookmarksViewController.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit
import Combine

class BookmarksViewController: UIViewController {
    var viewModel: BookmarksViewModel!
    private var cancellables: Set<AnyCancellable> = []

    private lazy var usersTableView: UsersTableView = {
        let tableView = UsersTableView(configuration: .bookmarks)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        navigationItem.title = "Saved Users"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onAppear()
    }

    private func setupUI() {
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
        viewModel.$savedUsers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                guard let self = self else { return }
                let cellDataArray = self.viewModel.createCellDataArray()
                self.usersTableView.updateUsers(with: users, cellDataArray: cellDataArray)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UsersTableViewDelegate
extension BookmarksViewController: UsersTableViewDelegate {
    func didSelectUser(_ user: UserEntity) {
        // Bookmarks'ta user selection'ı şimdilik boş
        // İleride user details'e navigate edebiliriz
        print("📖 Selected bookmark: \(user.fullName)")
    }

    func didTapFavoriteButton(for user: UserEntity) {
        viewModel.favouriteButtonAction(for: user)
    }

    func shouldLoadMoreData(currentCount: Int) {
        // Bookmarks'ta pagination yok, boş bırakıyoruz
    }

    func didPullToRefresh() {
        // Bookmarks'ta pull-to-refresh yok, boş bırakıyoruz
    }
}
