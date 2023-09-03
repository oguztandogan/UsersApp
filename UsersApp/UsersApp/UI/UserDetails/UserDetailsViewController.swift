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

//    let contentView: UIView = UserDetailsView()
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(stackView)
        view.backgroundColor = .green
        setupConstraints()
        setupViews()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    private func setupViews() {
        imageView.kf.setImage(with: URL(string: (viewModel.user.picture?.large)!))
        username.text = viewModel.user.fullName
        nationality.text = viewModel.user.nat
        age.text = viewModel.user.dob?.age?.description
        phoneNumber.text = viewModel.user.phone
    }

    deinit {
        print("TransactionCoordinator deinit")
    }
}
