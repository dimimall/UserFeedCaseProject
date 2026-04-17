//
//  CoreDataUserStore+UserStore.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 15/4/26.
//

import CoreData

extension CoreDataUserStore: UserStore {
    public func insert(_ user: [LocalFeedUser], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedUser.users(from: user, in: context)
                try context.save()
            })
        }
    }
    
    public func deleteAll(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func retrieveAll(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map {
                    CachedUserFeed(feed: $0.userFeed, timestamp: $0.timestamp)
                }
            })
        }
    }
    
    
}
