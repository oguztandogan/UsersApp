//
//  UserTableViewCell.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class UserTableViewCell: UITableViewCell {

    public static let reuseID = "UserTableViewCell"
    var buttonTapCallback: () -> Void = {}

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [username, nationality, age])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()

    lazy var userImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.contentMode = .scaleAspectFit
        temp.layer.cornerRadius = 6
        temp.clipsToBounds = true
        return temp
    }()

    lazy var username: InformationItemLabel = {
        let username = InformationItemLabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        return username
    }()

    lazy var nationality: InformationItemLabel = {
        let nationality = InformationItemLabel()
        nationality.translatesAutoresizingMaskIntoConstraints = false
        return nationality
    }()

    lazy var age: InformationItemLabel = {
        let age = InformationItemLabel()
        age.translatesAutoresizingMaskIntoConstraints = false
        return age
    }()

    lazy var favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favouriteButtonTap), for: .touchUpInside)
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(userImageView)
        addSubview(username)
        addSubview(nationality)
        addSubview(age)
        contentView.addSubview(favouriteButton)
        setupConstraints()
        selectionStyle = .none
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor),
            userImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            username.topAnchor.constraint(equalTo: topAnchor),
            username.bottomAnchor.constraint(equalTo: nationality.topAnchor),
            username.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 5),
            username.trailingAnchor.constraint(lessThanOrEqualTo: favouriteButton.leadingAnchor, constant: 15),

            nationality.bottomAnchor.constraint(equalTo: age.topAnchor),
            nationality.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 5),
            nationality.trailingAnchor.constraint(lessThanOrEqualTo: favouriteButton.leadingAnchor, constant: 15),

            age.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 5),
            age.trailingAnchor.constraint(lessThanOrEqualTo: favouriteButton.leadingAnchor, constant: 15),

            favouriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            favouriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            favouriteButton.heightAnchor.constraint(equalToConstant: 40),
            favouriteButton.widthAnchor.constraint(equalToConstant: 40)

        ])
    }

    func setData(cellData: UserTableViewCellData) {
        username.data = cellData.userNameData
        nationality.data = cellData.nationalityData
        age.data = cellData.ageData
        userImageView.kf.setImage(with: URL(string: (cellData.imageUrl)))
        setFavouriteButtonsImage(isSaved: cellData.isSaved)
    }

    @objc func favouriteButtonTap() {
        buttonTapCallback()
    }

    func setFavouriteButtonsImage(isSaved: Bool) {
        if isSaved {
            favouriteButton.setImage(UIImage(systemName: "heart.fill")?
                .withTintColor(.purple.withAlphaComponent(0.8), renderingMode: .alwaysOriginal), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(systemName: "heart")?
                .withTintColor(.purple.withAlphaComponent(0.8), renderingMode: .alwaysOriginal), for: .normal)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
