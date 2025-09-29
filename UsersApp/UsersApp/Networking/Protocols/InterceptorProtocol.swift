//
//  InterceptorProtocol.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import Foundation

protocol InterceptorProtocol: Sendable {
    func intercept(request: URLRequest) async throws -> URLRequest

    func intercept(data: Data, response: URLResponse, for request: URLRequest) async throws -> Data
}
