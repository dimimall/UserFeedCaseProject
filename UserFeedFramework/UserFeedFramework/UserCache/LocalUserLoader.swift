//
//  LocalUserLoader.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 15/4/26.
//

import Foundation


public final class LocalUserLoader {
    private let store: UserStore
    private let currentDate: () -> Date
    
    public init(store: UserStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalUserLoader: FeedCache {
    public typealias SaveResult = FeedCache.Result
    
    public func save(_ feed: [User], completion: @escaping (SaveResult) -> Void) {
        store.deleteAll(completion: { [weak self] deletionResult in
            guard let self = self else { return }
            
            switch deletionResult {
            case .success:
                self.cache(feed, with: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    public func cache(_ user: [User], with completion: @escaping (SaveResult) -> Void) {
        store.insert(user.toLocal(), timestamp: currentDate()) { [weak self]
            insertionResult in
            guard self != nil else { return }
            completion(insertionResult)
        }
    }
    
}

extension LocalUserLoader: UserLoader {
    public typealias LoadResult = UserLoader.Result
    
    public func loadUsers(completion: @escaping (LoadResult) -> Void) {
        store.retrieveAll { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(.some(cache)) where FeedUserCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                completion(.success(cache.feed.toModels()))
            case .success:
                completion(.success([]))
            }
        }
        
    }
}

extension LocalUserLoader {
    public typealias ValidationResult = Result<Void, Error>
    
    public func validateCache(completion: @escaping (ValidationResult) -> Void) {
        store.retrieveAll { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteAll(completion: completion)
            case let .success(.some(cache)) where !FeedUserCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                self.store.deleteAll(completion: completion)
            default:
                completion(.success(()))
            }
        }
    }
}

private extension Array where Element == User {
    func toLocal() -> [LocalFeedUser] {
        return map { LocalFeedUser(id: $0.id, firstName: $0.firstname, lastName: $0.lastname, email: $0.email, image: $0.imageURL!.absoluteString)}
    }
}

private extension Array where Element == LocalFeedUser {
    func toModels() -> [User] {
        return map {
            User(id: $0.id, firstname: $0.firstName, lastname: $0.lastName, email: $0.email, imageURL: URL(string: $0.image))
        }
    }
}
