//
//  Endpoint.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//

import UIKit

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var queries: [URLQueryItem]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "randomuser.me"
    }
}
