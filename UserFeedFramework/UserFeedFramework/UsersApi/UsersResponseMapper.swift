//
//  UsersResponseMapper.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 23/3/26.
//

import Foundation

final class UsersResponseMapper {
    private struct Root: Decodable {
        let users: [RemoteUserItem]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteUserItem] {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteUserLoader.Error.invalidData
        }

        return root.users
    }
}
