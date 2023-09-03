//
//  Users.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

struct Users: Codable {
    let results: [User]
    let info: Info
}

struct User: Codable {
    let gender: String?
    let name: Name?
    let dob: Dob?
    let phone: String?
    let id: Id?
    let picture: Picture?
    let nat: String?
    
    var fullName: String {
        guard let name = self.name else {
            return ""
        }

        var fullName = ""
        if let title = name.title {
            fullName += title + " "
        }
        if let first = name.first {
            fullName += first + " "
        }
        if let last = name.last {
            fullName += last
        }

        return fullName.trimmingCharacters(in: .whitespaces)
    }
}
struct Info: Codable {
    let seed: String?
    let results: Int?
    let page: Int?
    let version: String?
}
struct Picture: Codable {
    let large: String?
    let medium: String?
    let thumbnail: String?
}

struct Name: Codable {
    let title: String?
    let first: String?
    let last: String?
}

struct Dob: Codable {
    let date: String?
    let age: Int?
}

struct Id: Codable {
    let name: String?
    let value: String?
}
