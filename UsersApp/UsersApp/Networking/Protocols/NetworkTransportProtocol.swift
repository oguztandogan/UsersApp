//
//  NetworkTransportProtocol.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import Foundation

protocol NetworkTransportProtocol: Sendable {
    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse)
}
