//
//  SavedUser+CoreDataProperties.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 4.09.2023.
//
//

import Foundation
import CoreData

extension SavedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedUser> {
        return NSFetchRequest<SavedUser>(entityName: "SavedUser")
    }

    @NSManaged public var userName: String?
    @NSManaged public var userAge: String?
    @NSManaged public var userPictureUrl: String?
    @NSManaged public var userNationality: String?
    @NSManaged public var id: UUID?

}

extension SavedUser: Identifiable {}
