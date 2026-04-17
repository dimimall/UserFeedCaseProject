//
//  CoreDataHelpers.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 15/4/26.
//

import CoreData

extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores {
            loadError = $1
        }
        
        try loadError.map {
            throw $0
        }
        
        return container
    }
}

extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        let url = bundle.url(forResource: name, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: url)
    }
}
