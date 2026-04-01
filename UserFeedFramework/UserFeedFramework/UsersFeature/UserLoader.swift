//
//  UserLoader.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 23/3/26.
//

import Foundation

public protocol UserLoader {
    typealias Result = Swift.Result<[User], Error>
    func loadUsers(completion: @escaping (Result) -> Void)
}
