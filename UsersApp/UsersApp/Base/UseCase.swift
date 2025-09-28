//
//  UseCase.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

protocol UseCase {
    associatedtype Request
    associatedtype Response
    func execute(_ request: Request) async throws -> Response
}
