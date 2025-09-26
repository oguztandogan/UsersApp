//
//  UserDTO.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation

// MARK: - Data Transfer Objects (DTOs) for API
struct UsersDTO: Codable {
    let results: [UserDTO]
    let info: InfoDTO

    enum CodingKeys: String, CodingKey {
        case results
        case info
    }
}

struct UserDTO: Codable {
    let gender: String?
    let name: NameDTO?
    let dateOfBirth: DateOfBirthDTO?
    let phone: String?
    let picture: PictureDTO?
    let nationality: String?

    enum CodingKeys: String, CodingKey {
        case gender
        case name
        case dateOfBirth = "dob"
        case phone
        case picture
        case nationality = "nat"
    }
}

struct InfoDTO: Codable {
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

struct PictureDTO: Codable {
    let large: String?
    let medium: String?
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
}

struct NameDTO: Codable {
    let title: String?
    let first: String?
    let last: String?

    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }
}

struct DateOfBirthDTO: Codable {
    let date: String?
    let age: Int?

    enum CodingKeys: String, CodingKey {
        case date
        case age
    }
}

// MARK: - DTO to Domain Entity Mappers
extension UserDTO {
    func toDomainEntity() -> UserEntity {
        return UserEntity(
            gender: gender,
            name: name?.toDomainEntity(),
            dateOfBirth: dateOfBirth?.toDomainEntity(),
            phone: phone,
            picture: picture?.toDomainEntity(),
            nationality: nationality
        )
    }
}

extension NameDTO {
    func toDomainEntity() -> UserName {
        return UserName(title: title, first: first, last: last)
    }
}

extension DateOfBirthDTO {
    func toDomainEntity() -> UserDateOfBirth {
        return UserDateOfBirth(date: date, age: age)
    }
}

extension PictureDTO {
    func toDomainEntity() -> UserPicture {
        return UserPicture(large: large, medium: medium, thumbnail: thumbnail)
    }
}

extension InfoDTO {
    func toDomainEntity() -> ResponseInfo {
        return ResponseInfo(seed: seed, results: results, page: page, version: version)
    }
}

extension UsersDTO {
    func toDomainEntity() -> UsersResponse {
        return UsersResponse(
            users: results.map { $0.toDomainEntity() },
            info: info.toDomainEntity()
        )
    }
}
