//
//  UserMapper.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation
import CoreData

enum UserMapper {
    static func mapToDomain(_ dto: UsersDTO) -> UsersResponse {
        return UsersResponse(
            users: dto.results.map(mapToDomain),
            info: mapToDomain(dto.info)
        )
    }

    static func mapToDomain(_ dto: UserDTO) -> UserEntity {
        return UserEntity(
            id: UUID(),
            gender: dto.gender,
            name: dto.name.map(mapToDomain),
            dateOfBirth: dto.dateOfBirth.map(mapToDomain),
            phone: dto.phone,
            picture: dto.picture.map(mapToDomain),
            nationality: dto.nationality,
            isSaved: false
        )
    }

    static func mapToDomain(_ dto: NameDTO) -> UserName {
        return UserName(
            title: dto.title,
            first: dto.first,
            last: dto.last
        )
    }

    static func mapToDomain(_ dto: DateOfBirthDTO) -> UserDateOfBirth {
        return UserDateOfBirth(
            date: dto.date,
            age: dto.age
        )
    }

    static func mapToDomain(_ dto: PictureDTO) -> UserPicture {
        return UserPicture(
            large: dto.large,
            medium: dto.medium,
            thumbnail: dto.thumbnail
        )
    }

    static func mapToDomain(_ dto: InfoDTO) -> ResponseInfo {
        return ResponseInfo(
            seed: dto.seed,
            results: dto.results,
            page: dto.page,
            version: dto.version
        )
    }

    static func mapToDTO(_ entity: UserEntity) -> UserDTO {
        return UserDTO(
            gender: entity.gender,
            name: entity.name.map(mapToDTO),
            dateOfBirth: entity.dateOfBirth.map(mapToDTO),
            phone: entity.phone,
            picture: entity.picture.map(mapToDTO),
            nationality: entity.nationality
        )
    }

    static func mapToDTO(_ entity: UserName) -> NameDTO {
        return NameDTO(
            title: entity.title,
            first: entity.first,
            last: entity.last
        )
    }

    static func mapToDTO(_ entity: UserDateOfBirth) -> DateOfBirthDTO {
        return DateOfBirthDTO(
            date: entity.date,
            age: entity.age
        )
    }

    static func mapToDTO(_ entity: UserPicture) -> PictureDTO {
        return PictureDTO(
            large: entity.large,
            medium: entity.medium,
            thumbnail: entity.thumbnail
        )
    }

    static func mapToCoreData(_ entity: UserEntity, context: NSManagedObjectContext) -> SavedUser {
        let savedUser = SavedUser(context: context)
        savedUser.id = entity.id
        savedUser.userNationality = entity.nationality

        if let name = entity.name {
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
            savedUser.userName = fullName.trimmingCharacters(in: .whitespaces)
        }

        if let dob = entity.dateOfBirth {
            savedUser.userAge = dob.age != nil ? String(dob.age!) : nil
        }

        if let picture = entity.picture {
            savedUser.userPictureUrl = picture.medium ?? picture.large ?? picture.thumbnail
        }
        return savedUser
    }

    static func mapFromCoreData(_ savedUser: SavedUser) -> UserEntity {
        var name: UserName?
        if let fullName = savedUser.userName, !fullName.isEmpty {
            let components = fullName.split(separator: " ")
            switch components.count {
            case 1:
                name = UserName(title: nil, first: String(components[0]), last: nil)
            case 2:
                name = UserName(title: nil, first: String(components[0]), last: String(components[1]))
            case 3:
                name = UserName(title: String(components[0]), first: String(components[1]), last: String(components[2]))
            default:
                if components.count > 3 {
                    name = UserName(
                        title: String(components[0]),
                        first: String(components[1]),
                        last: components[2...].joined(separator: " ")
                    )
                }
            }
        }

        var dateOfBirth: UserDateOfBirth?
        if let ageString = savedUser.userAge, let age = Int(ageString) {
            dateOfBirth = UserDateOfBirth(date: nil, age: age)
        }

        var picture: UserPicture?
        if let pictureUrl = savedUser.userPictureUrl, !pictureUrl.isEmpty {
            picture = UserPicture(large: pictureUrl, medium: pictureUrl, thumbnail: pictureUrl)
        }
        return UserEntity(
            id: savedUser.id ?? UUID(),
            gender: nil,
            name: name,
            dateOfBirth: dateOfBirth,
            phone: nil,
            picture: picture,
            nationality: savedUser.userNationality,
            isSaved: true
        )
    }

    private static func hasValidName(_ name: UserName) -> Bool {
        return name.title != nil || name.first != nil || name.last != nil
    }

    private static func hasValidDateOfBirth(_ dob: UserDateOfBirth) -> Bool {
        return dob.date != nil || dob.age != nil
    }

    private static func hasValidPicture(_ picture: UserPicture) -> Bool {
        return picture.large != nil || picture.medium != nil || picture.thumbnail != nil
    }

    private static func isValidString(_ string: String?) -> Bool {
        return string != nil && !string!.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension UserMapper {
    static func mapToDomain(_ dtos: [UserDTO]) -> [UserEntity] {
        return dtos.map(mapToDomain)
    }

    static func mapToDTO(_ entities: [UserEntity]) -> [UserDTO] {
        return entities.map(mapToDTO)
    }

    static func mapFromCoreData(_ savedUsers: [SavedUser]) -> [UserEntity] {
        return savedUsers.map(mapFromCoreData)
    }

    static func mapToCoreData(_ entities: [UserEntity], context: NSManagedObjectContext) -> [SavedUser] {
        return entities.map { mapToCoreData($0, context: context) }
    }
}

protocol UserMapperProtocol: Sendable {
    func mapToDomain(_ dto: UsersDTO) -> UsersResponse
    func mapToDomain(_ dto: UserDTO) -> UserEntity
    func mapToDTO(_ entity: UserEntity) -> UserDTO
    func mapToCoreData(_ entity: UserEntity, context: NSManagedObjectContext) -> SavedUser
    func mapFromCoreData(_ savedUser: SavedUser) -> UserEntity
}

final class DefaultUserMapper: UserMapperProtocol, Sendable {
    func mapToDomain(_ dto: UsersDTO) -> UsersResponse {
        return UserMapper.mapToDomain(dto)
    }

    func mapToDomain(_ dto: UserDTO) -> UserEntity {
        return UserMapper.mapToDomain(dto)
    }

    func mapToDTO(_ entity: UserEntity) -> UserDTO {
        return UserMapper.mapToDTO(entity)
    }

    func mapToCoreData(_ entity: UserEntity, context: NSManagedObjectContext) -> SavedUser {
        return UserMapper.mapToCoreData(entity, context: context)
    }

    func mapFromCoreData(_ savedUser: SavedUser) -> UserEntity {
        return UserMapper.mapFromCoreData(savedUser)
    }
}
