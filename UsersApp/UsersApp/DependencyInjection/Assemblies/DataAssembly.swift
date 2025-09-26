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

        // MARK: - Remote Data Sources
        container.register(UsersRemoteDataSourceProtocol.self) { _ in
            UsersRemoteDataSource()
        }.inObjectScope(.container)

        // MARK: - Local Data Sources
        container.register(UsersLocalDataSourceProtocol.self) { resolver in
            UsersLocalDataSource(coreDataService: resolver.resolve(CoreDataServiceable.self)!)
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
