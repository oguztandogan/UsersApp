//
//  UsersServiceMock.swift
//  UsersAppTests
//
//  Created by Oguz Tandogan on 5.09.2023.
//

import Foundation

final class UsersServiceMock: Mockable, UsersServiceable {
    func getUsers(pageNumber: String) async -> Result<Users, RequestError> {
        return .success(loadJSON(filename: "users_response", type: Users.self))
    }
}
