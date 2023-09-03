//
//  UserDetailsView.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import UIKit

class UserDetailsView: UIView {
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var username: UILabel = {
        let username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        return username
    }()

    lazy var nationality: UILabel = {
        let nationality = UILabel()
        nationality.translatesAutoresizingMaskIntoConstraints = false
        return nationality
    }()

    lazy var age: UILabel = {
        let age = UILabel()
        age.translatesAutoresizingMaskIntoConstraints = false
        return age
    }()

    lazy var phoneNumber: UILabel = {
        let phoneNumber = UILabel()
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        return phoneNumber
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [username, nationality, age, phoneNumber])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(stackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: 20),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
