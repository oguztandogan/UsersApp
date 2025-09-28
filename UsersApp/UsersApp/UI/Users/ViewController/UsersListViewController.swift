//
//  UsersListViewController.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit
import Combine

class UsersListViewController: UIViewController {
    var viewModel: UsersListViewModel!
    private var cancellables: Set<AnyCancellable> = []

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search users"
        searchController.searchBar.searchBarStyle = .minimal
        
        // Customize search bar appearance
        if let searchTextField = searchController.searchBar.searchTextField {
            searchTextField.backgroundColor = .appSearchBarBackground
            searchTextField.textColor = .appOnSurface
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: "Search users",
                attributes: [.foregroundColor: UIColor.appOnSurfaceVariant]
            )
        }
        
        return searchController
    }()

    private lazy var usersTableView: UsersTableView = {
        let tableView = UsersTableView(configuration: .default)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
        viewModel.onAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    private func setupUI() {
        view.backgroundColor = .appBackground
        view.addSubview(usersTableView)
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Users"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        // Style navigation bar - same as list background
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appBackground // Liste background ile aynı
        appearance.titleTextAttributes = [.foregroundColor: UIColor.appOnSurface]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appOnSurface]
        
        // Remove default shadow/border
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        // Add settings button to the right
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "slider.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        settingsButton.tintColor = .appOnSurface
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc private func settingsButtonTapped() {
        // Handle settings button tap
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

// MARK: - UISearchResultsUpdating
extension UsersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Handle search functionality
        guard let searchText = searchController.searchBar.text else { return }
        // viewModel.searchUsers(with: searchText)
    }
}

// MARK: - UsersTableViewDelegate
extension UsersListViewController: UsersTableViewDelegate {
    func didSelectUser(_ user: UserEntity) {
        viewModel.navigateToUserDetails(for: user)
    }

    func didTapFavoriteButton(for user: UserEntity) {
        viewModel.favouriteButtonAction(for: user)
    }

    func shouldLoadMoreData(currentCount: Int) {
        viewModel.fetchUsers(isPagination: true, isRefreshing: false)
    }

    func didPullToRefresh() {
        viewModel.fetchUsers(isPagination: false, isRefreshing: true)
    }
}
