//
//  UserDetailsNavigationData.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

struct UserDetailsNavigationData: NavigationData {
    let user: UserEntity
    let shouldAnimate: Bool
    let presentationStyle: PresentationStyle
    init(user: UserEntity, shouldAnimate: Bool = true, presentationStyle: PresentationStyle = .push) {
        self.user = user
        self.shouldAnimate = shouldAnimate
        self.presentationStyle = presentationStyle
    }
}
