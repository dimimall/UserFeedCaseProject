//
//  HTTPClientSpy.swift
//  UserFeedFrameworkTests
//
//  Created by Dimitra Malliarou on 26/3/26.
//

import Foundation
import UserFeedFramework

class HTTPClientSpy: HTTPClient {
    func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> any UserFeedFramework.HTTPClientTask {
        messages.append((url,completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }
    
    
    private struct Task: HTTPClientTask {
        let callback: () -> Void
        func cancel() {
            callback()
        }
    }
    
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    private(set) var cancelledURLs = [URL]()
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
}
