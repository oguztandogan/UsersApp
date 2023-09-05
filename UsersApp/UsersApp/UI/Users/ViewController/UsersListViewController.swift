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
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        viewModel.onAppear()
        bindTableView()
        self.navigationItem.title = "Users"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
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
        tableView.backgroundColor = .systemMint
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
            withIdentifier: "UserTableViewCell") as? UserTableViewCell
        else { return UITableViewCell() }
        cell.setData(cellData: viewModel.setCellData(index: indexPath.row))
        cell.buttonTapCallback = {
            self.viewModel.favouriteButtonAction(index: indexPath.row)
            cell.setFavouriteButtonsImage(isSaved: self.viewModel.users[indexPath.row].isSaved)
        }
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
