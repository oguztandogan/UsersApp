//
//  UserDetailsViewController.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import Foundation
import UIKit
import Combine
import Kingfisher

class UserDetailsViewController: UIViewController {
    var viewModel: UserDetailsViewModel!
    var cancellables: Set<AnyCancellable> = []

    private lazy var contentView: UserDetailsContentView = {
        let contentView = UserDetailsContentView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        self.navigationItem.title = "User Details"
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    private func setupViews() {
        view.backgroundColor = .systemMint
        view.addSubview(contentView)
        contentView.data = viewModel.getContentViewData()
    }

    @objc private func favouriteButtonAction() {
        viewModel.favouriteButtonAction()
    }
}
