//
//  User.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

// MARK: - Domain Entities
struct UserEntity {
    let id: UUID
    let gender: String?
    let name: UserName?
    let dateOfBirth: UserDateOfBirth?
    let phone: String?
    let picture: UserPicture?
    let nationality: String?
    var isSaved: Bool

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

    init(id: UUID = UUID(),
         gender: String?,
         name: UserName?,
         dateOfBirth: UserDateOfBirth?,
         phone: String?,
         picture: UserPicture?,
         nationality: String?,
         isSaved: Bool = false) {
        self.id = id
        self.gender = gender
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.phone = phone
        self.picture = picture
        self.nationality = nationality
        self.isSaved = isSaved
    }
}

struct UserName {
    let title: String?
    let first: String?
    let last: String?
}

struct UserDateOfBirth {
    let date: String?
    let age: Int?
}

struct UserPicture {
    let large: String?
    let medium: String?
    let thumbnail: String?
}

struct UsersResponse {
    let users: [UserEntity]
    let info: ResponseInfo
}

struct ResponseInfo {
    let seed: String?
    let results: Int?
    let page: Int?
    let version: String?
}
