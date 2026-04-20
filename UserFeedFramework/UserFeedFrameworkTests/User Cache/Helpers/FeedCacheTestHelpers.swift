//
//  FeedCacheTestHelpers.swift
//  UserFeedFrameworkTests
//
//  Created by Dimitra Malliarou on 17/4/26.
//

import Foundation
import UserFeedFramework

func uniqueUser() -> User {
    return User(id: 1, firstname: "any", lastname: "any", email: "any", imageURL: anyURL())
}

func uniqueUserFeed() -> (models: [User], local: [LocalFeedUser]) {
    let models = [uniqueUser(), uniqueUser()]
    let local: [LocalFeedUser] = models.map { LocalFeedUser(id: $0.id, firstName: $0.firstname, lastName: $0.lastname, email: $0.lastname, image: $0.imageURL!.absoluteString)
        
    }
    return (models, local)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
