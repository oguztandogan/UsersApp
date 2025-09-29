//
//  LottieLoadingView.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import UIKit
import Lottie

final class LottieLoadingView: UIView {

    private let animationView: LottieAnimationView

    init(animationName: String, frame: CGRect = .zero) {
        self.animationView = LottieAnimationView(name: "loading")
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 150),
            animationView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    func start() {
        isHidden = false
        animationView.play()
    }

    func stop() {
        animationView.stop()
        isHidden = true
    }
}
