//
//  XCTestCase+FailableInsertFeedStoreSpecs.swift
//  UserFeedFrameworkTests
//
//  Created by Dimitra Malliarou on 19/4/26.
//

import XCTest
import UserFeedFramework

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {

    func assertThatInsertDeliversErrorOnInsertionError(on sut: UserStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueUserFeed().local, Date()), to: sut)
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: UserStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueUserFeed().local, Date()), to: sut)
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
