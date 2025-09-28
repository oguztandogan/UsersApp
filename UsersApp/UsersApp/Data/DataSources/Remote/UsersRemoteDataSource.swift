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

/// Updated remote data source using the new networking layer
/// Swift 6 compliant with proper error handling
class UsersRemoteDataSource: UsersRemoteDataSourceProtocol, @unchecked Sendable {
    
    private let networkService: UsersNetworkServiceProtocol
    
    init(networkService: UsersNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getUsers(pageNumber: String) async throws -> UsersResponse {
        return try await networkService.getUsers(page: pageNumber, results: 25)
    }
}

// MARK: - Additional Remote Data Source Methods
extension UsersRemoteDataSource {
    
    /// Convenience method to get users with integer page number
    func getUsers(page: Int) async throws -> UsersResponse {
        return try await getUsers(pageNumber: String(page))
    }
    
    /// Convenience method to get first page
    func getFirstPage() async throws -> UsersResponse {
        return try await getUsers(pageNumber: "1")
    }
}
