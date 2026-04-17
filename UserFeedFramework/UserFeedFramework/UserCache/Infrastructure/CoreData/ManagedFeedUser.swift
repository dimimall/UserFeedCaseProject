//
//  ManagedFeedUser.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 15/4/26.
//

import CoreData

@objc(ManagedFeedUser)
class ManagedFeedUser: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var email: String
    @NSManaged var image: String
}

extension ManagedFeedUser {
    static func first(with email: String, in context: NSManagedObjectContext) throws -> ManagedFeedUser? {
        let request = NSFetchRequest<ManagedFeedUser>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K == %@", argumentArray:  [#keyPath(ManagedFeedUser.email), email])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func users(from localUser: [LocalFeedUser], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localUser.map { local in
            let managed = ManagedFeedUser(context: context)
            managed.id = Int(local.id)
            managed.email = local.email
            managed.firstName = local.firstName
            managed.lastName = local.lastName
            managed.image = local.image
            return managed
        })
    }
    
    var local: LocalFeedUser {
        return LocalFeedUser(id: Int(id), firstName: firstName, lastName: lastName, email: email, image: image)
    }
}
