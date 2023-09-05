//
//  InformationItemLabel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 5.09.2023.
//

import UIKit

class InformationItemLabel: UIView {
    var data: InformationItemLabelData? {
        didSet {
            setupViews()
            setupConstraints()
        }
    }

    lazy var titleLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.lineBreakMode = .byWordWrapping
        temp.contentMode = .center
        temp.textAlignment = .left
        temp.adjustsFontSizeToFitWidth = true
        temp.lineBreakMode = .byTruncatingTail
        temp.numberOfLines = 1
        return temp
    }()

    lazy var infoLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.lineBreakMode = .byWordWrapping
        temp.contentMode = .center
        temp.textAlignment = .left
        temp.adjustsFontSizeToFitWidth = true
        temp.lineBreakMode = .byTruncatingTail
        temp.numberOfLines = 1
        return temp
    }()

    lazy var stackView: UIStackView = {
        let temp = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
        temp.spacing = 2
        temp.layer.cornerRadius = 10
        temp.axis = .horizontal
        temp.clipsToBounds = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        temp.isLayoutMarginsRelativeArrangement = true
        return temp
    }()

    init(data: InformationItemLabelData? = nil) {
        self.data = data
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(stackView)
        titleLabel.text = data?.title
        infoLabel.text = data?.text
        stackView.backgroundColor = data?.backgroundColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: data?.titleFontSize ?? 14)
        titleLabel.textColor = data?.textColor
        infoLabel.font = UIFont.systemFont(ofSize: data?.textFontSize ?? 12)
        infoLabel.textColor = data?.textColor
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
