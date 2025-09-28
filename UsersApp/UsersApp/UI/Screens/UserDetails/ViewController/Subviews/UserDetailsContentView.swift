//
//  UserDetailsContentView.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 5.09.2023.
//

import UIKit
import Kingfisher

class UserDetailsContentView: UIView {
    var data: UserDetailsContentViewData? {
        didSet {
            setupViews()
            setupConstraints()
        }
    }

    init(data: UserDetailsContentViewData? = nil) {
        self.data = data
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 10
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()

    lazy var username: LabelView = {
        let username = LabelView(data: .largeTitle())
        username.translatesAutoresizingMaskIntoConstraints = false
        return username
    }()

    lazy var nationality: LabelView = {
        let nationality = LabelView(data: .secondary())
        nationality.translatesAutoresizingMaskIntoConstraints = false
        return nationality
    }()

    lazy var age: LabelView = {
        let age = LabelView(data: .secondary())
        age.translatesAutoresizingMaskIntoConstraints = false
        return age
    }()

    lazy var phoneNumber: LabelView = {
        let phoneNumber = LabelView(data: .secondary())
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

    func setupViews() {
        addSubview(imageView)
        addSubview(stackView)
        
        // Update LabelViews with new data
        username.data = data?.username
        nationality.data = data?.nationality
        age.data = data?.age
        phoneNumber.data = data?.phoneNumber
        
        if let imageUrl = data?.imageUrl, let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            imageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -40),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
