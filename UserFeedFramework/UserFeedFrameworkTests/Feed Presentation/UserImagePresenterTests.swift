//
//  UserImagePresenterTests.swift
//  UserFeedFrameworkTests
//
//  Created by Dimitra Malliarou on 24/4/26.
//

import XCTest
import UserFeedFramework

final class UserImagePresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingImageData_displayLoadingMessage() {
        let (sut, view) = makeSUT()
        let user = uniqueUser()
        
        sut.didStartLoadingImageData(for: user)
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.email, user.email)
        XCTAssertEqual(message?.firstName, user.firstname)
        XCTAssertEqual(message?.lastName, user.lastname)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertNil(message?.image)
    }
    
    func test_didFinishLoadingImageData_displaysRetryOnFailedImageTransformation() {
        let (sut, view) = makeSUT()
        let user = uniqueUser()
        
        sut.didFinishLoadingImageData(for: user, with: Data())
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.email, user.email)
        XCTAssertEqual(message?.firstName, user.firstname)
        XCTAssertEqual(message?.lastName, user.lastname)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }
    
    func test_didFinishLoadingImageData_displaysImageOnSuccessfulTransformation() {
        let user = uniqueUser()
        let transformationData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformationData })
        
        sut.didFinishLoadingImageData(for: user, with: Data())
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.email, user.email)
        XCTAssertEqual(message?.firstName, user.firstname)
        XCTAssertEqual(message?.lastName, user.lastname)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertEqual(message?.image, transformationData)
    }
    
    func test_didFinishLoadingImageDataWithError_displaysRetry() {
        let user = uniqueUser()
        let (sut, view) = makeSUT()
        
        sut.didFailLoadingImageData(for: user, with: anyNSError())
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.email, user.email)
        XCTAssertEqual(message?.firstName, user.firstname)
        XCTAssertEqual(message?.lastName, user.lastname)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },file: StaticString = #file,
    line: UInt = #line) -> (sut: UserImagePresenter<ViewSpy, AnyImage>, view: ViewSpy){
        let view  = ViewSpy()
        let sut = UserImagePresenter(view: view, imageTransformer: imageTransformer)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut: sut, view: view)
    }
    
    private var fail: (Data) -> AnyImage? {
        return { _ in nil }
    }
    
    private struct AnyImage: Equatable {}
    
    private class ViewSpy: UserImageView {
        private(set) var messages = [UserImageViewModel<AnyImage>]()
        
        func display(_ model: UserImageViewModel<AnyImage>) {
            messages.append(model)
        }
    }
}
