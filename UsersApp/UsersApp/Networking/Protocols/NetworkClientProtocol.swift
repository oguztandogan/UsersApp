//
//  NetworkClientProtocol.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

protocol NetworkClientProtocol: Sendable {
    func request<T: Codable & Sendable>(
        endpoint: EndpointProtocol,
        responseType: T.Type
    ) async throws -> T
}
