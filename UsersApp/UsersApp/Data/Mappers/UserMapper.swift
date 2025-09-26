//
//  UserMapper.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

/// Pure mapper functions for converting between DTOs and Domain Entities
/// These are thread-safe, testable, and contain no side effects
enum UserMapper {

    // MARK: - DTO to Domain Entity Mapping

    /// Maps UsersDTO to UsersResponse domain entity
    static func mapToDomain(_ dto: UsersDTO) -> UsersResponse {
        return UsersResponse(
            users: dto.results.map(mapToDomain),
            info: mapToDomain(dto.info)
        )
    }

    /// Maps UserDTO to UserEntity domain entity
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
    
    /// Maps NameDTO to UserName domain entity
    static func mapToDomain(_ dto: NameDTO) -> UserName {
        return UserName(
            title: dto.title,
            first: dto.first,
            last: dto.last
        )
    }
    
    /// Maps DateOfBirthDTO to UserDateOfBirth domain entity
    static func mapToDomain(_ dto: DateOfBirthDTO) -> UserDateOfBirth {
        return UserDateOfBirth(
            date: dto.date,
            age: dto.age
        )
    }
    
    /// Maps PictureDTO to UserPicture domain entity
    static func mapToDomain(_ dto: PictureDTO) -> UserPicture {
        return UserPicture(
            large: dto.large,
            medium: dto.medium,
            thumbnail: dto.thumbnail
        )
    }
    
    /// Maps InfoDTO to ResponseInfo domain entity
    static func mapToDomain(_ dto: InfoDTO) -> ResponseInfo {
        return ResponseInfo(
            seed: dto.seed,
            results: dto.results,
            page: dto.page,
            version: dto.version
        )
    }
    
    // MARK: - Domain Entity to DTO Mapping (for outgoing requests)
    
    /// Maps UserEntity to UserDTO for API requests
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
    
    /// Maps UserName to NameDTO
    static func mapToDTO(_ entity: UserName) -> NameDTO {
        return NameDTO(
            title: entity.title,
            first: entity.first,
            last: entity.last
        )
    }
    
    /// Maps UserDateOfBirth to DateOfBirthDTO
    static func mapToDTO(_ entity: UserDateOfBirth) -> DateOfBirthDTO {
        return DateOfBirthDTO(
            date: entity.date,
            age: entity.age
        )
    }
    
    /// Maps UserPicture to PictureDTO
    static func mapToDTO(_ entity: UserPicture) -> PictureDTO {
        return PictureDTO(
            large: entity.large,
            medium: entity.medium,
            thumbnail: entity.thumbnail
        )
    }
    
    // MARK: - CoreData Mapping
    
    /// Maps UserEntity to SavedUser CoreData entity
    static func mapToCoreData(_ entity: UserEntity, context: NSManagedObjectContext) -> SavedUser {
        let savedUser = SavedUser(context: context)
        savedUser.id = entity.id
        savedUser.userNationality = entity.nationality
        
        // Map full name from UserName
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
        
        // Map age from date of birth
        if let dob = entity.dateOfBirth {
            savedUser.userAge = dob.age != nil ? String(dob.age!) : nil
        }
        
        // Map picture URL (prefer medium, fallback to large, then thumbnail)
        if let picture = entity.picture {
            savedUser.userPictureUrl = picture.medium ?? picture.large ?? picture.thumbnail
        }
        
        return savedUser
    }
    
    /// Maps SavedUser CoreData entity to UserEntity
    static func mapFromCoreData(_ savedUser: SavedUser) -> UserEntity {
        // Parse full name back to UserName components (best effort)
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
        
        // Parse age back to UserDateOfBirth
        var dateOfBirth: UserDateOfBirth?
        if let ageString = savedUser.userAge, let age = Int(ageString) {
            dateOfBirth = UserDateOfBirth(date: nil, age: age)
        }
        
        // Create picture with available URL
        var picture: UserPicture?
        if let pictureUrl = savedUser.userPictureUrl, !pictureUrl.isEmpty {
            picture = UserPicture(large: pictureUrl, medium: pictureUrl, thumbnail: pictureUrl)
        }
        
        return UserEntity(
            id: savedUser.id ?? UUID(),
            gender: nil, // Not available in SavedUser
            name: name,
            dateOfBirth: dateOfBirth,
            phone: nil, // Not available in SavedUser
            picture: picture,
            nationality: savedUser.userNationality,
            isSaved: true // Since it's saved in CoreData
        )
    }
    
    // MARK: - Validation Helpers
    
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

// MARK: - Array Extensions for Batch Mapping
extension UserMapper {
    
    /// Maps array of UserDTO to array of UserEntity
    static func mapToDomain(_ dtos: [UserDTO]) -> [UserEntity] {
        return dtos.map(mapToDomain)
    }
    
    /// Maps array of UserEntity to array of UserDTO
    static func mapToDTO(_ entities: [UserEntity]) -> [UserDTO] {
        return entities.map(mapToDTO)
    }
    
    /// Maps array of SavedUser to array of UserEntity
    static func mapFromCoreData(_ savedUsers: [SavedUser]) -> [UserEntity] {
        return savedUsers.map(mapFromCoreData)
    }
    
    /// Maps array of UserEntity to array of SavedUser
    static func mapToCoreData(_ entities: [UserEntity], context: NSManagedObjectContext) -> [SavedUser] {
        return entities.map { mapToCoreData($0, context: context) }
    }
}

// MARK: - Mapper Protocol for Dependency Injection
protocol UserMapperProtocol: Sendable {
    func mapToDomain(_ dto: UsersDTO) -> UsersResponse
    func mapToDomain(_ dto: UserDTO) -> UserEntity
    func mapToDTO(_ entity: UserEntity) -> UserDTO
    func mapToCoreData(_ entity: UserEntity, context: NSManagedObjectContext) -> SavedUser
    func mapFromCoreData(_ savedUser: SavedUser) -> UserEntity
}

// MARK: - Concrete Mapper Implementation
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

// MARK: - Core Data Import
import CoreData

// Extension to work with NSManagedObjectContext
extension UserMapper {
    
    /// Updates an existing SavedUser with data from UserEntity
    static func updateCoreData(_ savedUser: SavedUser, with entity: UserEntity) {
        savedUser.id = entity.id
        savedUser.userNationality = entity.nationality
        
        // Update full name
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
        } else {
            savedUser.userName = nil
        }
        
        // Update age
        if let dob = entity.dateOfBirth {
            savedUser.userAge = dob.age != nil ? String(dob.age!) : nil
        } else {
            savedUser.userAge = nil
        }
        
        // Update picture URL
        if let picture = entity.picture {
            savedUser.userPictureUrl = picture.medium ?? picture.large ?? picture.thumbnail
        } else {
            savedUser.userPictureUrl = nil
        }
    }
}
