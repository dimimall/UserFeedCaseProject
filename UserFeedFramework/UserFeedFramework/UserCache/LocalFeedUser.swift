//
//  LocalFeedUser.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 1/4/26.
//

import Foundation

public struct LocalFeedUser: Equatable {
    public let id: Int
    public let firstName: String
    public let lastName: String
    public let email: String
    public let image: String
    
    public init(id: Int, firstName: String, lastName: String, email: String, image: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.image = image
    }
}
