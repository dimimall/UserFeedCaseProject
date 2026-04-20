//
//  FeedErrorViewModel.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 20/4/26.
//

public struct UserErrorViewModel {
    public let message: String?
    
    static var noError: UserErrorViewModel {
        return UserErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> UserErrorViewModel {
        return UserErrorViewModel(message: message)
    }
}
