//
//  UsersRemoteDataSource.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

protocol UsersRemoteDataSourceProtocol: Sendable {
    func getUsers(pageNumber: String) async throws -> UsersResponse
}

class UsersRemoteDataSource: UsersRemoteDataSourceProtocol, @unchecked Sendable {
    private let networkService: UsersNetworkServiceProtocol
    init(networkService: UsersNetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getUsers(pageNumber: String) async throws -> UsersResponse {
        return try await networkService.getUsers(page: pageNumber, results: 25)
    }
}

extension UsersRemoteDataSource {
    func getUsers(page: Int) async throws -> UsersResponse {
        return try await getUsers(pageNumber: String(page))
    }

    func getFirstPage() async throws -> UsersResponse {
        return try await getUsers(pageNumber: "1")
    }
}
