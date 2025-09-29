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
        return contentView
    }()

    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("button.bookmark".localized, for: .normal)
        button.backgroundColor = .appPrimary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8

        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        navigationItem.title = "navigation.user_details".localized
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            bookmarkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bookmarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bookmarkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupViews() {
        view.backgroundColor = .appBackground

        view.addSubview(contentView)
        view.addSubview(bookmarkButton)
        contentView.data = viewModel.getContentViewData()
    }

    private func bindViewModel() {
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.contentView.data = self.viewModel.getContentViewData()
                self.updateBookmarkButtonState()
            }
            .store(in: &cancellables)
    }

    private func updateBookmarkButtonState() {
        if viewModel.user.isSaved {
            bookmarkButton.setTitle("button.remove_bookmark".localized, for: .normal)
            bookmarkButton.backgroundColor = .systemRed
        } else {
            bookmarkButton.setTitle("button.bookmark".localized, for: .normal)
            bookmarkButton.backgroundColor = .appPrimary
        }
    }

    @objc private func bookmarkButtonTapped() {
        animateButtonTap()
        viewModel.favouriteButtonAction()
    }

    private func animateButtonTap() {
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.bookmarkButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    self.bookmarkButton.transform = CGAffineTransform.identity
                })
            }
        )
    }
}
