//
//  UserDetailsViewController.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import Combine
import Foundation
import Kingfisher
import UIKit

class UserDetailsViewController: UIViewController {
    var viewModel: UserDetailsViewModel!
    var cancellables: Set<AnyCancellable> = []
    private lazy var contentView: UserDetailsContentView = {
        let contentView = UserDetailsContentView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.accessibilityIdentifier = "UserDetailsContentView"
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        navigationItem.title = "User Details"
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    private func setupViews() {
        view.backgroundColor = .appBackground
        view.accessibilityIdentifier = "UserDetailsViewController"
        view.addSubview(contentView)
        contentView.data = viewModel.getContentViewData()
    }

    @objc private func favouriteButtonAction() {
        viewModel.favouriteButtonAction()
    }
}
