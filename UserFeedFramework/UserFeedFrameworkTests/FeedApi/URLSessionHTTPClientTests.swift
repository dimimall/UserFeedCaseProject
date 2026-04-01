//
//  URLSessionHTTPClientTests.swift
//  UserFeedFrameworkTests
//
//  Created by Dimitra Malliarou on 30/3/26.
//

import XCTest
@testable import UserFeedFramework

final class URLSessionHTTPClientTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        URLProtocolStub.removeStub()
    }

    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for data")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.url, url)
            exp.fulfill()
        }
        
        makeSUT().get(url: url) {
            _ in
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_cancelGetFromURL_cancelsURLRequest() {
        let receivedError = resultErrorFor(taskHandler: { $0.cancel() }) as? NSError
       
        XCTAssertEqual(receivedError?.code, URLError.cancelled.rawValue)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError()
        
        let receivedError = resultErrorFor((data: nil, response: nil, error: requestError)) as NSError?
        
        XCTAssertEqual(receivedError?.domain, requestError.domain)
        XCTAssertEqual(receivedError?.code, requestError.code)
    }
    
    func test_getsFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultErrorFor((data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nil, error: anyNSError())))
        
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: nil)))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let expectedData = anyData()
        let expectedResponse = anyHTTPURLResponse()
        
        let receivedValue = resultValuesFor(
            (data: expectedData, response: expectedResponse, error: nil)
        )
        
        XCTAssertEqual(receivedValue?.data, expectedData)
        XCTAssertEqual(receivedValue?.response.url, expectedResponse.url)
        XCTAssertEqual(receivedValue?.response.statusCode, expectedResponse.statusCode)
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithoutData() {
        let expectedResponse = anyHTTPURLResponse()
        
        let receivedValue = resultValuesFor(
            (data: nil, response: expectedResponse, error: nil)
        )
        
        let emptyData = Data()
        XCTAssertEqual(receivedValue?.data, emptyData)
        XCTAssertEqual(receivedValue?.response.url, expectedResponse.url)
        XCTAssertEqual(receivedValue?.response.statusCode, expectedResponse.statusCode)
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func resultValuesFor(_ values: (data: Data?, response: URLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)?
    {
        let result = self.resultFor(values, file: file, line: line)
        
        switch result {
        case let .success(value):
            return value
        default :
            XCTFail("Expected success with value, got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultErrorFor(_ values: (data: Data?, response: URLResponse?, error: Error?)? = nil, taskHandler: (HTTPClientTask) -> Void = { _ in }, file: StaticString = #file, line: UInt = #line) -> Error?
    {
        let result = self.resultFor(values, taskHandler: taskHandler, file: file, line: line)
        
        switch result {
        case let .failure(error):
            return error
            default :
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(_ values: (data: Data?, response: URLResponse?, error: Error?)?, taskHandler: (HTTPClientTask) -> Void = { _ in }, file: StaticString = #file, line: UInt = #line) -> HTTPClient.Result {
        values.map {
            URLProtocolStub.stub(data: $0, response: $1, error: $2)
        }
        
        let sut = makeSUT(file: file, line: line)
        let expectation = expectation(description: "Wait for completion")
        
        var receivedResult: HTTPClient.Result?
        taskHandler(sut.get(url: anyURL()) { result in
            receivedResult = result
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
        return receivedResult!
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
