//
//  URLSessionHTTPClient.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 24/3/26.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}

    private final class URLSessionTaskWrapper: HTTPClientTask {
        private var wrapped: URLSessionTask?

        init(wrapped: URLSessionTask) {
            self.wrapped = wrapped
        }

        func cancel() {
            wrapped?.cancel()
        }
    }

    public func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                }

                guard let response = response as? HTTPURLResponse else {
                    throw UnexpectedValuesRepresentation()
                }

                return (data ?? Data(), response)
            })
        }

        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
