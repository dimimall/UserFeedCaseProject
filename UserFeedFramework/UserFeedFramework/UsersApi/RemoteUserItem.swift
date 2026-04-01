//
//  RemoteUserItem.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 23/3/26.
//

import Foundation

public struct RemoteUserItem: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let image: String
}
