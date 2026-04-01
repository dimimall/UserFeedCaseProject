//
//  PagedUsers.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 23/3/26.
//

import Foundation


public struct PagedUsers: Hashable {
    let users: [User]
    let total: Int
    let skip: Int
    let limit: Int
}
