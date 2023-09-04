//
//  UsersService.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

protocol UsersServiceable {
    func getUsers() async -> Result<Users, RequestError>
}

struct UsersService: HTTPClient, UsersServiceable {
    func getUsers() async -> Result<Users, RequestError> {
        return await sendRequest(endpoint: UsersEndpoint.userList, responseModel: Users.self)
    }
}
