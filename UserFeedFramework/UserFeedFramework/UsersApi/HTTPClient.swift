//
//  HTTPClient.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 24/3/26.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(url: URL,completion: @escaping (Result) -> Void) -> HTTPClientTask
}
