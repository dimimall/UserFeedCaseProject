//
//  UserStoreSpy.swift
//  UserFeedFrameworkTests
//
//  Created by Dimitra Malliarou on 17/4/26.
//

import Foundation
import UserFeedFramework

class UserStoreSpy: UserStore {
    func insert(_ user: [UserFeedFramework.LocalFeedUser], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletion.append(completion)
        receivedMessages.append(.insert(user, timestamp))
    }
    
    func deleteAll(completion: @escaping DeletionCompletion) {
        deletionCompletion.append(completion)
        receivedMessages.append(.deleteCachedUser)
    }
    
    func retrieveAll(completion: @escaping RetrievalCompletion) {
        retrievalCompletion.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    
    enum ReceivedMessage: Equatable {
        case deleteCachedUser
        case insert([LocalFeedUser], Date)
        case retrieve
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    private var retrievalCompletion: [RetrievalCompletion] = []
    private var deletionCompletion: [DeletionCompletion] = []
    private var insertionCompletion: [InsertionCompletion] = []
    
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletion[index](.failure(error))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletion[index](Result.success(()))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletion[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletion[index](Result.success(()))
    }
    
    func completeRetrieval(with users: [LocalFeedUser], timestamp: Date, at index: Int = 0) {
        retrievalCompletion[index](.success(CachedUserFeed(feed: users, timestamp: timestamp)))
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletion[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletion[index](Result.success(.none))
    }
}
