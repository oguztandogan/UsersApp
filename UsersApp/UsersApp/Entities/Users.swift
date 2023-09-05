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

    enum CodingKeys: String, CodingKey {
        case results
        case info
    }
}

struct User: Codable {
    let gender: String?
    let name: Name?
    let dateOfBirth: DateOfBirth?
    let phone: String?
    let picture: Picture?
    let nationality: String?
    var isSaved: Bool = false
    let uuid: UUID = UUID()
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

    enum CodingKeys: String, CodingKey {
        case gender
        case name
        case dateOfBirth = "dob"
        case phone
        case picture
        case nationality = "nat"
    }
}

struct Info: Codable {
    let seed: String?
    let results: Int?
    let page: Int?
    let version: String?

    enum CodingKeys: String, CodingKey {
        case seed
        case results
        case page
        case version = "info_version"
    }
}

struct Picture: Codable {
    let large: String?
    let medium: String?
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
}

struct Name: Codable {
    let title: String?
    let first: String?
    let last: String?

    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }
}

struct DateOfBirth: Codable {
    let date: String?
    let age: Int?

    enum CodingKeys: String, CodingKey {
        case date
        case age
    }
}
