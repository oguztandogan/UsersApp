//
//  BookmarksViewController.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit
import Combine
import Kingfisher

class BookmarksViewController: UIViewController {
    var viewModel: BookmarksViewModel!
    var refreshControl = UIRefreshControl()
    var cancellables: Set<AnyCancellable> = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindTableView()
        self.navigationItem.title = "Saved Users"

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        viewModel.onAppear()

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
        viewModel.$savedUsers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.savedUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(
            withIdentifier: "UserTableViewCell") as? UserTableViewCell
        else { return UITableViewCell() }
        cell.setData(cellData: viewModel.setCellData(index: indexPath.row))
        cell.buttonTapCallback = {
            self.viewModel.favouriteButtonAction(index: indexPath.row)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
