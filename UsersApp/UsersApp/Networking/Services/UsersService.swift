//
//  UsersService.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

protocol UsersServiceable {
    func getUsers(pageNumber: String) async -> Result<Users, RequestError>
}

struct UsersService: HTTPClient, UsersServiceable {
    func getUsers(pageNumber: String) async -> Result<Users, RequestError> {
        return await sendRequest(endpoint: UsersEndpoint.userList(pageNumber), responseModel: Users.self)
    }
}
