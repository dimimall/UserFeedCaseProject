//
//  FeedUserStore.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 1/4/26.
//

import Foundation

public typealias CachedUserFeed = (feed: [FeedUserStore], timestamp: Date)

public protocol FeedUserStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<[FeedUserStore], Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func insert(_ user: [FeedUserStore], completion: @escaping InsertionCompletion)
    func deleteAll(completion: @escaping DeletionCompletion)
    func retrieveAll(completion: @escaping RetrievalCompletion)
    
}
