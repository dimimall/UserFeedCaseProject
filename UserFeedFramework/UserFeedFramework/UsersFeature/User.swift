//
//  User.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 23/3/26.
//

import Foundation

public struct User: Hashable {
    public var id: Int
    public var firstname: String
    public var lastname: String
    public var email: String
    public var imageURL: URL?
    
    public init(id: Int, firstname: String, lastname: String, email: String, imageURL: URL? = nil) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.imageURL = imageURL
    }
}
