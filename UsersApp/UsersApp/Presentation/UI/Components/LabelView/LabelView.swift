//
//  LabelView.swift
//  UsersApp
//
//  Created by UsersApp on 28.09.2025.
//

import UIKit

class LabelView: UIView {
    var data: LabelViewData? {
        didSet {
            configure()
        }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.accessibilityIdentifier = "LabelView"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    convenience init(data: LabelViewData) {
        self.init(frame: .zero)
        self.data = data
        configure()
    }

    private func setupUI() {
        addSubview(label)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configure() {
        guard let data = data else { return }
        label.text = data.text
        label.textColor = data.textColor
        label.font = data.font
        label.textAlignment = data.textAlignment
        label.numberOfLines = data.numberOfLines
        backgroundColor = data.backgroundColor
    }

    func updateText(_ text: String?) {
        label.text = text
    }
}
