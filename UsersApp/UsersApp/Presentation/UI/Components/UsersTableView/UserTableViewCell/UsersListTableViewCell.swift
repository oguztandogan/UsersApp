//
//  UsersListTableViewCell.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class UserTableViewCell: UITableViewCell {
    static let reuseID = "UserTableViewCell"
    var buttonTapCallback: () -> Void = {}
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [username, nationality, age])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()

    private lazy var username: LabelView = {
        let username = LabelView(data: .primary())
        username.translatesAutoresizingMaskIntoConstraints = false
        return username
    }()

    private lazy var nationality: LabelView = {
        let nationality = LabelView(data: .secondary())
        nationality.translatesAutoresizingMaskIntoConstraints = false
        return nationality
    }()

    private lazy var age: LabelView = {
        let age = LabelView(data: .secondary())
        age.translatesAutoresizingMaskIntoConstraints = false
        return age
    }()

    private lazy var favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favouriteButtonTap), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()

        selectionStyle = .default
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .appOnSurfaceVariant.withAlphaComponent(0.1)
        self.selectedBackgroundView = selectedBackgroundView
    }

    private func setupUI() {
        contentView.addSubview(userImageView)
        contentView.addSubview(contentStackView)
        contentView.addSubview(favouriteButton)

        backgroundColor = .appSurface
        contentView.backgroundColor = .appSurface

        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets(top: 0, left: 76, bottom: 0, right: 16)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 60),
            userImageView.heightAnchor.constraint(equalToConstant: 60),

            contentStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12),
            contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: favouriteButton.leadingAnchor, constant: -12),

            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favouriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favouriteButton.widthAnchor.constraint(equalToConstant: 40),
            favouriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setData(cellData: UserTableViewCellData) {
        username.data = cellData.userNameData
        nationality.data = cellData.nationalityData
        age.data = cellData.ageData
        if let url = URL(string: cellData.imageUrl) {
            userImageView.kf.setImage(with: url)
        }
        setFavouriteButtonsImage(isSaved: cellData.isSaved)
    }

    @objc func favouriteButtonTap() {
        animateButtonTap()
        buttonTapCallback()
    }

    private func animateButtonTap() {
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.favouriteButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.1,
                    animations: {
                        self.favouriteButton.transform = .identity
                    }
                )
            }
        )
    }

    func setFavouriteButtonsImage(isSaved: Bool) {
        if isSaved {
            favouriteButton.setImage(UIImage(systemName: "bookmark.fill")?
                .withTintColor(.appPrimary, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(systemName: "bookmark")?
                .withTintColor(.appOnSurfaceVariant, renderingMode: .alwaysOriginal), for: .normal)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
