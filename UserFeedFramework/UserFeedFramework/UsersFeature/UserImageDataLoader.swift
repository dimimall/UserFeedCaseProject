//
//  UserImageDataLoader.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 24/3/26.
//

import Foundation

public protocol UserImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(for user: User, completion: @escaping (Result) -> Void)
}
