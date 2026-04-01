//
//  RemoteUsersResponse.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 24/3/26.
//

import Foundation

public struct RemoteUsersResponse: Decodable {
    let users: [RemoteUserItem]
    let total: Int
    let skip: Int
    let limit: Int
}
