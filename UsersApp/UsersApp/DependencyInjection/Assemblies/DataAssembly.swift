//
//  DataAssembly.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import Swinject

class DataAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Core Data Service
        container.register(CoreDataServiceable.self) { _ in
            CoreDataService()
        }.inObjectScope(.container)

        // MARK: - Networking Layer
        container.register(NetworkTransportProtocol.self) { _ in
            URLSessionTransport.default()
        }.inObjectScope(.container)
        
        container.register(TokenProvider.self) { _ in
            DefaultTokenProvider()
        }.inObjectScope(.container)
        
        container.register(NetworkClientProtocol.self) { resolver in
            let transport = resolver.resolve(NetworkTransportProtocol.self)!
            let tokenProvider = resolver.resolve(TokenProvider.self)!
            
            let interceptors: [InterceptorProtocol] = [
                AuthInterceptor(tokenProvider: tokenProvider),
                LoggingInterceptor.development()
            ]
            
            return APIClient(transport: transport, interceptors: interceptors)
        }.inObjectScope(.container)
        
        container.register(UserMapperProtocol.self) { _ in
            DefaultUserMapper()
        }.inObjectScope(.container)
        
        container.register(UsersNetworkServiceProtocol.self) { resolver in
            UsersNetworkService(
                apiClient: resolver.resolve(NetworkClientProtocol.self)!,
                mapper: resolver.resolve(UserMapperProtocol.self)!
            )
        }.inObjectScope(.container)

        // MARK: - Remote Data Sources
        container.register(UsersRemoteDataSourceProtocol.self) { resolver in
            UsersRemoteDataSource(
                networkService: resolver.resolve(UsersNetworkServiceProtocol.self)!
            )
        }.inObjectScope(.container)

        // MARK: - Local Data Sources
        container.register(UsersLocalDataSourceProtocol.self) { resolver in
            UsersLocalDataSource(
                coreDataService: resolver.resolve(CoreDataServiceable.self)!,
                mapper: resolver.resolve(UserMapperProtocol.self)!
            )
        }.inObjectScope(.container)

        // MARK: - Repositories
        container.register(UsersRepository.self) { resolver in
            UsersRepositoryImpl(
                remoteDataSource: resolver.resolve(UsersRemoteDataSourceProtocol.self)!,
                localDataSource: resolver.resolve(UsersLocalDataSourceProtocol.self)!
            )
        }.inObjectScope(.container)
    }
}
