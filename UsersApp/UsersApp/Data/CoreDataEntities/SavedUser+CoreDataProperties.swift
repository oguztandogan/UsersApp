//
//  SavedUser+CoreDataProperties.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//
//

import CoreData
import Foundation

public extension SavedUser {
    @nonobjc class func fetchRequest() -> NSFetchRequest<SavedUser> {
        return NSFetchRequest<SavedUser>(entityName: "SavedUser")
    }

    @NSManaged var userName: String?
    @NSManaged var userAge: String?
    @NSManaged var userPictureUrl: String?
    @NSManaged var userNationality: String?
    @NSManaged var id: UUID?
}

extension SavedUser: Identifiable {}
