//
//  UsersTableView.swift
//  UsersApp
//
//  Created by Assistant on 28.09.2025.
//

import Combine
import UIKit

protocol UsersTableViewDelegate: AnyObject {
    func didSelectUser(_ user: UserEntity)
    func didTapFavoriteButton(for user: UserEntity)
    func shouldLoadMoreData(currentCount: Int)
    func didPullToRefresh()
}

class UsersTableView: UIView {
    struct Configuration {
        let showPullToRefresh: Bool
        let showPagination: Bool
        static let `default` = Configuration(showPullToRefresh: true, showPagination: true)
        static let bookmarks = Configuration(showPullToRefresh: false, showPagination: false)
    }

    weak var delegate: UsersTableViewDelegate?
    private let configuration: Configuration

    private typealias DataSource = UITableViewDiffableDataSource<Section, CellDataWrapper>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CellDataWrapper>
    private enum Section: CaseIterable {
        case main
    }

    private lazy var dataSource: DataSource = .init(tableView: tableView) { [weak self] tableView, indexPath, cellDataWrapper in
        guard let self = self,
              let cell = tableView.dequeueReusableCell(
                  withIdentifier: UserTableViewCell.reuseID,
                  for: indexPath
              ) as? UserTableViewCell
        else {
            return UITableViewCell()
        }
        cell.setData(cellData: cellDataWrapper.cellData)

        cell.buttonTapCallback = { [weak self] in
            guard let self = self else { return }
            self.delegate?.didTapFavoriteButton(for: cellDataWrapper.user)
        }

        if self.configuration.showPagination {
            self.checkForPagination(at: indexPath)
        }
        return cell
    }

    private struct CellDataWrapper: Hashable {
        let user: UserEntity
        let cellData: UserTableViewCellData
        func hash(into hasher: inout Hasher) {
            hasher.combine(user.id)
        }

        static func == (lhs: CellDataWrapper, rhs: CellDataWrapper) -> Bool {
            return lhs.user.id == rhs.user.id &&
                lhs.user.isSaved == rhs.user.isSaved
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .appBackground
        tableView.delegate = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseID)

        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .appOutline
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 76, bottom: 0, right: 16)

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        tableView.tableFooterView = UIView()

        if configuration.showPullToRefresh {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
        return tableView
    }()

    private var cellDataWrappers: [CellDataWrapper] = []

    init(configuration: Configuration = .default) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupUI()
    }

    override init(frame: CGRect) {
        configuration = .default
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        configuration = .default
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(tableView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func updateUsers(with users: [UserEntity], cellDataArray: [UserTableViewCellData], animated: Bool = true) {
        guard users.count == cellDataArray.count else {
            assertionFailure("Users and cellData arrays must have same count")
            return
        }
        cellDataWrappers = zip(users, cellDataArray).map { user, cellData in
            CellDataWrapper(user: user, cellData: cellData)
        }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(cellDataWrappers, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animated)
        dataSource.defaultRowAnimation = .fade
        DispatchQueue.main.async { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

    func updateUser(_ user: UserEntity, with cellData: UserTableViewCellData, animated: Bool = true) {
        let newWrapper = CellDataWrapper(user: user, cellData: cellData)
        var snapshot = dataSource.snapshot()
        if let existingIndex = cellDataWrappers.firstIndex(where: { $0.user.id == user.id }) {
            cellDataWrappers[existingIndex] = newWrapper
            let existingWrapper = snapshot.itemIdentifiers[existingIndex]
            snapshot.reloadItems([existingWrapper])
            dataSource.apply(snapshot, animatingDifferences: animated)
        }
    }

    private func checkForPagination(at indexPath: IndexPath) {
        let lastIndex = cellDataWrappers.count - 3
        if indexPath.row == lastIndex {
            delegate?.shouldLoadMoreData(currentCount: cellDataWrappers.count)
        }
    }

    @objc private func handleRefresh() {
        delegate?.didPullToRefresh()
    }
}

extension UsersTableView: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < cellDataWrappers.count else { return }
        let user = cellDataWrappers[indexPath.row].user
        delegate?.didSelectUser(user)
    }
}
