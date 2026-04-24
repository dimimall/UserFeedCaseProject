//
//  UserImagePresenter.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 24/4/26.
//

import Foundation
import UIKit

public protocol UserImageView {
    associatedtype Image
    
    func display(_ model: UserImageViewModel<Image>)
}

public final class UserImagePresenter<View: UserImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: User) {
        view.display(UserImageViewModel(email: model.email, firstName: model.firstname, lastName: model.lastname, image: nil, isLoading: true, shouldRetry: false))
    }
    
    public func didFinishLoadingImageData(for model: User, with data:Data) {
        let image = imageTransformer(data)
        
        view.display(UserImageViewModel(email: model.email, firstName: model.firstname, lastName: model.lastname, image: image, isLoading: false, shouldRetry: image == nil))
    }
    
    public func didFailLoadingImageData(for model: User, with error: Error) {
        view.display(UserImageViewModel(email: model.email, firstName: model.firstname, lastName: model.lastname, image: nil, isLoading: false, shouldRetry: true))
    }
}
