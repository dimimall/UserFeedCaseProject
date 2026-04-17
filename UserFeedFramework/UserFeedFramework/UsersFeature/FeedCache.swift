//
//  FeedCache.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 15/4/26.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [User], completion: @escaping (Result) -> Void)
}
