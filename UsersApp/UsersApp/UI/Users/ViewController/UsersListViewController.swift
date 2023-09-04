//
//  UsersListViewController.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit
import Combine
import Kingfisher

class UsersListViewController: UIViewController {
    var viewModel: UsersListViewModel!
    var refreshControl = UIRefreshControl()
    var cancellables: Set<AnyCancellable> = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .insetGrouped)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UsersListTableViewCell.self, forCellReuseIdentifier: "UsersListTableViewCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupTableView()
        viewModel.onAppear()
        bindTableView()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func bindTableView() {
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @objc func refreshData() {
        viewModel.fetchUsers(isPagination: false, isRefreshing: false)
        refreshControl.endRefreshing()
    }
}

extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(
            withIdentifier: "UsersListTableViewCell") as? UsersListTableViewCell
        else { return UITableViewCell() }
        cell.username.text = viewModel.users[indexPath.row].fullName
        cell.age.text = viewModel.users[indexPath.row].dateOfBirth?.age?.description
        cell.nationality.text = viewModel.users[indexPath.row].nationality
        cell.userImageView.kf.setImage(with: URL(string: (viewModel.users[indexPath.row].picture?.medium)!))

        let lastIndex = self.viewModel.users.count - 3
        if indexPath.row == lastIndex {
            viewModel.fetchUsers(isPagination: true, isRefreshing: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.navigateToUserDetails(index: indexPath.row)
    }
}
