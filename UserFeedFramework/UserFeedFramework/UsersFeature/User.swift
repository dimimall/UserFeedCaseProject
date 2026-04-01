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
}
