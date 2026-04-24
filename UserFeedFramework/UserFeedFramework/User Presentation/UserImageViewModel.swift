//
//  UserImageViewModel.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 24/4/26.
//

import Foundation
import UIKit

public struct UserImageViewModel<Image> {
    public let email: String?
    public let firstName: String?
    public let lastName: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    public var hasEmail: Bool {
        return email != nil
    }
}
