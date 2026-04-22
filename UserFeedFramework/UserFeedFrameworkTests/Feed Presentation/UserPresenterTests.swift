//
//  UserPresenterTests.swift
//  UserFeedFrameworkTests
//
//  Created by Dimitra Malliarou on 22/4/26.
//

import XCTest
import UserFeedFramework

final class UserPresenterTests: XCTestCase {

    func test_title_isLocalized() {
        XCTAssertEqual(UserPresenter.title, localized("USER_VIEW_TITLE"))
    }
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingUser_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingUser()
        
        XCTAssertEqual(view.messages, [.display(errorMessage: .none), .display(isLoading: true)])
    }
    
    func test_didFinishLoadingUser_displaysUserAndStopsLoading() {
        let (sut, view) = makeSUT()
        let user = uniqueUserFeed().models
        
        sut.didFinishLoadingUser(with: user)
        
        XCTAssertEqual(view.messages, [.display(user: user), .display(isLoading: false)])
    }
    
    func test_didFinishLoadingFeedWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        
        let (sut, view) = makeSUT()
        sut.didFinishLoadingUser(with: anyNSError())
        
        XCTAssertEqual(view.messages, [.display(errorMessage: localized("USER_VIEW_CONNECTION_ERROR")), .display(isLoading: false)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: UserPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = UserPresenter(feedView: view, loadingView: view, errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "User"
        let bundle = Bundle(for: UserPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        
        if value == key {
            XCTFail("Missing localized string for \(key) in table \(table)", file: file, line: line)
        }
        return value
    }
    
    private class ViewSpy: UserView, UserLoadingView, UserErrorView {
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(user: [User])
        }
        
        private(set) var messages = Set<Message>()
        
        
        func display(_ viewModel: UserFeedFramework.UserViewModel) {
            messages.insert(.display(user: viewModel.user))
        }
        
        func display(_ viewModel: UserFeedFramework.UserLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: UserFeedFramework.UserErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        
    }
}
