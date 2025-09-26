//
//  UsersRemoteDataSource.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

protocol UsersRemoteDataSourceProtocol: Sendable {
    func getUsers(pageNumber: String) async -> Result<UsersResponse, NetworkError>
}

/// Updated remote data source using the new networking layer
/// Swift 6 compliant with proper error handling
class UsersRemoteDataSource: UsersRemoteDataSourceProtocol, @unchecked Sendable {
    
    private let networkService: UsersNetworkServiceProtocol
    
    init(networkService: UsersNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getUsers(pageNumber: String) async -> Result<UsersResponse, NetworkError> {
        do {
            let response = try await networkService.getUsers(page: pageNumber, results: 25)
            return .success(response)
        } catch let networkError as NetworkError {
            return .failure(networkError)
        } catch {
            return .failure(.unknown(error))
        }
    }
}

// MARK: - Additional Remote Data Source Methods
extension UsersRemoteDataSource {
    
    /// Convenience method to get users with integer page number
    func getUsers(page: Int) async -> Result<UsersResponse, NetworkError> {
        return await getUsers(pageNumber: String(page))
    }
    
    /// Convenience method to get first page
    func getFirstPage() async -> Result<UsersResponse, NetworkError> {
        return await getUsers(pageNumber: "1")
    }
}
