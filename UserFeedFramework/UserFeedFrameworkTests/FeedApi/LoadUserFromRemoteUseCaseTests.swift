//
//  UserFeedFrameworkTests.swift
//  UserFeedFrameworkTests
//
//  Created by Dimitra Malliarou on 23/3/26.
//

import XCTest
@testable import UserFeedFramework

final class LoadUserFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestDataFromURL() {
        let (sut, client) = makeSUT()
        sut.loadUsers { _ in }
        XCTAssertEqual(client.requestedURLs, [URL(string: "https://a-url.com")!])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadUsers { _ in }
        sut.loadUsers { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPStatusCode() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 500, 502, 503, 504]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeItemsJson([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200ErrorHTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJson = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJson)
        })
    }
    
    func test_load_deliversNoItemsOn200ValidHTTPResponseWithEmptyJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            let json = makeItemsJson([])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let user1 = makeItem(id: 1, firstName: "Arthur", lastName: "Dent", email: "arthur@example.com", image: "http://example.com/arthur.jpg")
        let user2 = makeItem(id: 2, firstName: "Barbara", lastName: "Gorodnya", email: "barbara@example.com", image: "http://example.com/barbara.jpg")
        
        expect(sut, toCompleteWith: .success([user1.model, user2.model]), when: {
            let json = makeItemsJson([user1.json, user2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceDeallocated() {
        let url = URL(string: "https://a-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteUserLoader? = RemoteUserLoader(url: url, client: client)
        
        var capturedResults = [RemoteUserLoader.Result]()
        sut?.loadUsers { result in
            capturedResults.append(result)
        }
        
        sut = nil
        
        client.complete(withStatusCode: 200, data: makeItemsJson([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteUserLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteUserLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
        
    private func failure(_ error: RemoteUserLoader.Error) -> RemoteUserLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(id: Int, firstName: String, lastName: String, email: String, image: String) -> (model: User, json: [String: Any]) {
        let item = User(id: id, firstname: firstName, lastname: lastName, email: email, imageURL: URL(string: image))
        
        let json = [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "image": image
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func makeItemsJson(_ items: [[String: Any]]) -> Data {
        let json = ["users": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteUserLoader, toCompleteWith expectedResult: RemoteUserLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = XCTestExpectation(description: "Wait for load completion")
        
        sut.loadUsers { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, "Received items do not match expected items", file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError.domain, expectedError.domain, "Received error domain does not match expected error domain", file: file, line: line)
                default :
                XCTFail("Received result \(receivedResult) does not match expected result \(expectedResult)", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
}

