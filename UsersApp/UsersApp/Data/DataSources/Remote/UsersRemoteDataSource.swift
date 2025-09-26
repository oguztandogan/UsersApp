//
//  UsersRemoteDataSource.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

protocol UsersRemoteDataSourceProtocol {
    func getUsers(pageNumber: String) async -> Result<UsersDTO, RequestError>
}

class UsersRemoteDataSource: HTTPClient, UsersRemoteDataSourceProtocol {
    func getUsers(pageNumber: String) async -> Result<UsersDTO, RequestError> {
        return await sendRequest(endpoint: UsersEndpoint.userList(pageNumber), responseModel: UsersDTO.self)
    }
}
