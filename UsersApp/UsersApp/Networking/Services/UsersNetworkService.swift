//
//  UsersNetworkService.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

protocol UsersNetworkServiceProtocol: Sendable {
    func getUsers(page: String?, results: Int) async throws -> UsersResponse
    func getUser(id: String) async throws -> UserEntity
}

final class UsersNetworkService: UsersNetworkServiceProtocol, Sendable {
    private let apiClient: NetworkClientProtocol
    private let mapper: UserMapperProtocol

    init(
        apiClient: NetworkClientProtocol,
        mapper: UserMapperProtocol = DefaultUserMapper()
    ) {
        self.apiClient = apiClient
        self.mapper = mapper
    }

    func getUsers(page: String?, results: Int = 25) async throws -> UsersResponse {
        let endpoint = UserEndpoint.userList(page: page, results: results)
        let usersDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UsersDTO.self
        )
        return mapper.mapToDomain(usersDTO)
    }

    func getUser(id: String) async throws -> UserEntity {
        let endpoint = UserEndpoint.userDetail(id: id)
        let userDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UserDTO.self
        )
        return mapper.mapToDomain(userDTO)
    }
}

extension UsersNetworkService {
    func getUsers(page: Int, results: Int = 25) async throws -> UsersResponse {
        return try await getUsers(page: String(page), results: results)
    }

    func getFirstPageUsers(results: Int = 25) async throws -> UsersResponse {
        return try await getUsers(page: "1", results: results)
    }

    func getDefaultUsers() async throws -> UsersResponse {
        return try await getUsers(page: "1", results: 25)
    }
}
