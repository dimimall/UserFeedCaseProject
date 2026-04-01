//
//  RemoteUserLoader.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 23/3/26.
//

import Foundation

public class RemoteUserLoader: UserLoader {
    public func loadUsers(completion: @escaping (Result) -> Void) {
        client.get(url: url){ [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteUserLoader.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    

    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = UserLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let remoteUsers = try UsersResponseMapper.map(data, from: response)
            return .success(remoteUsers.toModels())
        }
        catch {
            return .failure(error)
        }
    }
    
}
private extension Array where Element == RemoteUserItem {
    func toModels() -> [User] {
        return map { User(id: $0.id, firstname: $0.firstName, lastname: $0.lastName, email: $0.email, imageURL: URL(string: $0.image))
        }
    }
}
