//
//  UsersListTableViewCell.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import UIKit

class UsersListTableViewCell: UITableViewCell {

    public static let reuseID = "UsersListTableViewCell"

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
        return temp
    }()

    lazy var username: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.lineBreakMode = .byWordWrapping
        temp.font = UIFont(name: "American Typewriter", size: 17)
        temp.textColor = ColorAssets.violetCrayola.value
        temp.numberOfLines = 0
        temp.contentMode = .center
        temp.textAlignment = .left
        return temp
    }()

    lazy var age: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.lineBreakMode = .byWordWrapping
        temp.font = UIFont(name: "American Typewriter", size: 14)
        temp.textColor = ColorAssets.violetCrayola.value
        temp.numberOfLines = 0
        temp.contentMode = .center
        temp.textAlignment = .left
        return temp
    }()

    lazy var nationality: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.lineBreakMode = .byWordWrapping
        temp.numberOfLines = 0
        temp.contentMode = .center
        temp.font = UIFont(name: "American Typewriter", size: 10)
        temp.textColor = ColorAssets.violetCrayola.value
        temp.textAlignment = .left
        return temp
    }()

    lazy var favouriteButton: UIButton = {
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(userImageView)
        addSubview(stackView)
        setupConstraints()
        selectionStyle = .none
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor),
            userImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant:  15)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
