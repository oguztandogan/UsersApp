//
//  LabelView.swift
//  UsersApp
//
//  Created by UsersApp on 28.09.2025.
//

import UIKit

class LabelView: UIView {
    var text: String? {
        didSet {
            label.text = text
        }
    }

    var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }

    var font: UIFont? {
        didSet {
            label.font = font
        }
    }

    var textAlignment: NSTextAlignment {
        get { label.textAlignment }
        set { label.textAlignment = newValue }
    }

    var numberOfLines: Int {
        get { label.numberOfLines }
        set { label.numberOfLines = newValue }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
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

    convenience init(text: String? = nil,
                     textColor: UIColor? = nil,
                     font: UIFont? = nil) {
        self.init(frame: .zero)
        self.text = text
        self.textColor = textColor ?? .appOnSurface
        self.font = font ?? UIFont.systemFont(ofSize: 16)
    }

    private func setupUI() {
        addSubview(label)
        setupConstraints()

        label.textColor = .appOnSurface
        label.font = UIFont.systemFont(ofSize: 16)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(text: String?,
                   textColor: UIColor = .appOnSurface,
                   font: UIFont = UIFont.systemFont(ofSize: 16)) {
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}

extension LabelView {
    static func primaryLabel(text: String? = nil) -> LabelView {
        return LabelView(
            text: text,
            textColor: .appOnSurface,
            font: UIFont.systemFont(ofSize: 16, weight: .medium)
        )
    }

    static func secondaryLabel(text: String? = nil) -> LabelView {
        return LabelView(
            text: text,
            textColor: .appOnSurfaceVariant,
            font: UIFont.systemFont(ofSize: 14, weight: .regular)
        )
    }

    static func captionLabel(text: String? = nil) -> LabelView {
        return LabelView(
            text: text,
            textColor: .appOnSurfaceVariant,
            font: UIFont.systemFont(ofSize: 12, weight: .regular)
        )
    }
}
