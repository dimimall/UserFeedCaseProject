//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  UserFeedFrameworkTests
//
//  Created by Dimitra Malliarou on 19/4/26.
//

import XCTest
import UserFeedFramework

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {

    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: UserStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: UserStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }
}
