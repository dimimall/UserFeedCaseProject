//
//  FeedUserCachePolicy.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 1/4/26.
//

import Foundation


final class FeedUserCachePolicy {
    private init() {}
    
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool{
        guard let maxCacheAge = calendar.date(byAdding: .day, value: Self.maxCacheAgeInDays, to: date) else {
            return false
        }
        
        return date < maxCacheAge
    }
}
