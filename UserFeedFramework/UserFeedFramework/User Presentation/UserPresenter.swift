//
//  UserPresenter.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 20/4/26.
//

import Foundation

public protocol UserView {
    func display(_ viewModel: UserViewModel)
}

public protocol UserLoadingView {
    func display(_ viewModel: UserLoadingViewModel)
}

public protocol UserErrorView {
    func display(_ viewModel: UserErrorViewModel)
}

public final class UserPresenter {
    private let feedView: UserView
    private let loadingView: UserLoadingView
    private let errorView: UserErrorView
    
    private var userLoadError: String {
        return NSLocalizedString("USER_VIEW_CONNECTION_ERROR", tableName: "User", bundle: Bundle(for: UserPresenter.self), comment: "Error message displayed when we can't load the image user from the server")
    }
    
    public init(feedView: UserView, loadingView: UserLoadingView, errorView: UserErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var title: String {
        return NSLocalizedString("USER_VIEW_TITLE", tableName: "User", bundle: Bundle(for: UserPresenter.self), comment: "Title of the user view")
    }
    
    public func didStartLoadingUser() {
        errorView.display(.noError)
        loadingView.display(UserLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingUser(with user: [User]) {
        loadingView.display(UserLoadingViewModel(isLoading: false))
        feedView.display(UserViewModel(user: user))
    }
    
    public func didFinishLoadingUser(with error: Error) {
        errorView.display(.error(message: userLoadError))
        loadingView.display(UserLoadingViewModel(isLoading: false))
    }
}
