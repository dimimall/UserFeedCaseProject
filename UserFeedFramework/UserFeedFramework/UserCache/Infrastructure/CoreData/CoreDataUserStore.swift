//
//  CoreDataUserStore.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 15/4/26.
//

import CoreData

final public class CoreDataUserStore {
    private static let modelName: String = "UserStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataUserStore.self))
    
    private let queue = DispatchQueue(label: "CoreDataUserStore.queue", qos: .userInitiated)
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataUserStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: CoreDataUserStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(_ actions: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        queue.async {
            context.performAndWait {
                actions(context)
            }
        }
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let cordinator = self.container.persistentStoreCoordinator
            try? cordinator.persistentStores.forEach(cordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
