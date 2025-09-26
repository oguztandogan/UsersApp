//
//  UsersNetworkService.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

/// Protocol defining the users network service interface
protocol UsersNetworkServiceProtocol: Sendable {
    /// Fetches users from the API
    /// - Parameters:
    ///   - page: Page number to fetch
    ///   - results: Number of results per page
    /// - Returns: UsersResponse containing users and pagination info
    func getUsers(page: String?, results: Int) async throws -> UsersResponse

    /// Fetches a specific user by ID
    /// - Parameter id: User identifier
    /// - Returns: UserEntity for the requested user
    func getUser(id: String) async throws -> UserEntity

    /// Creates a new user
    /// - Parameter user: User data to create
    /// - Returns: Created UserEntity
    func createUser(_ user: UserEntity) async throws -> UserEntity

    /// Updates an existing user
    /// - Parameters:
    ///   - id: User identifier
    ///   - user: Updated user data
    /// - Returns: Updated UserEntity
    func updateUser(id: String, user: UserEntity) async throws -> UserEntity

    /// Deletes a user
    /// - Parameter id: User identifier to delete
    func deleteUser(id: String) async throws
}

/// Implementation of the users network service using the new networking layer
final class UsersNetworkService: UsersNetworkServiceProtocol, Sendable {

    // MARK: - Properties
    private let apiClient: NetworkClientProtocol
    private let mapper: UserMapperProtocol

    // MARK: - Initialization
    init(
        apiClient: NetworkClientProtocol,
        mapper: UserMapperProtocol = DefaultUserMapper()
    ) {
        self.apiClient = apiClient
        self.mapper = mapper
    }

    // MARK: - UsersNetworkServiceProtocol Implementation

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

    func createUser(_ user: UserEntity) async throws -> UserEntity {
        let userDTO = mapper.mapToDTO(user)
        let endpoint = try UserEndpoint.createUser(user: userDTO)

        let createdUserDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UserDTO.self
        )

        return mapper.mapToDomain(createdUserDTO)
    }

    func updateUser(id: String, user: UserEntity) async throws -> UserEntity {
        let userDTO = mapper.mapToDTO(user)
        let endpoint = try UserEndpoint.updateUser(id: id, user: userDTO)

        let updatedUserDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UserDTO.self
        )

        return mapper.mapToDomain(updatedUserDTO)
    }

    func deleteUser(id: String) async throws {
        let endpoint = UserEndpoint.deleteUser(id: id)
        try await apiClient.requestVoid(endpoint: endpoint)
    }
}

// MARK: - Convenience Extensions
extension UsersNetworkService {

    /// Fetches users for a specific page number
    func getUsers(page: Int, results: Int = 25) async throws -> UsersResponse {
        return try await getUsers(page: String(page), results: results)
    }

    /// Fetches the first page of users
    func getFirstPageUsers(results: Int = 25) async throws -> UsersResponse {
        return try await getUsers(page: "1", results: results)
    }

    /// Fetches users with default pagination
    func getDefaultUsers() async throws -> UsersResponse {
        return try await getUsers(page: "1", results: 25)
    }
}

// MARK: - Factory for UsersNetworkService
enum UsersNetworkServiceFactory {

    /// Creates a users network service with default configuration
    static func create() -> UsersNetworkService {
        let transport = URLSessionTransport.default()
        let interceptors: [InterceptorProtocol] = [
            LoggingInterceptor.development()
        ]
        let apiClient = APIClient(transport: transport, interceptors: interceptors)

        return UsersNetworkService(apiClient: apiClient)
    }

    /// Creates a users network service with authentication
    static func createWithAuth(tokenProvider: TokenProvider) -> UsersNetworkService {
        let transport = URLSessionTransport.default()
        let interceptors: [InterceptorProtocol] = [
            AuthInterceptor(tokenProvider: tokenProvider),
            LoggingInterceptor.development()
        ]
        let apiClient = APIClient(transport: transport, interceptors: interceptors)

        return UsersNetworkService(apiClient: apiClient)
    }

    /// Creates a users network service for testing
    static func createForTesting(mockResponses: [String: (Data, URLResponse)] = [:]) -> UsersNetworkService {
        let transport = MockTransport(mockResponses: mockResponses)
        let interceptors: [InterceptorProtocol] = [
            LoggingInterceptor(logLevel: .debug)
        ]
        let apiClient = APIClient(transport: transport, interceptors: interceptors)

        return UsersNetworkService(apiClient: apiClient)
    }

    /// Creates a users network service with custom configuration
    static func create(
        transport: NetworkTransportProtocol,
        interceptors: [InterceptorProtocol] = [],
        mapper: UserMapperProtocol = DefaultUserMapper()
    ) -> UsersNetworkService {
        let apiClient = APIClient(transport: transport, interceptors: interceptors)
        return UsersNetworkService(apiClient: apiClient, mapper: mapper)
    }
}
