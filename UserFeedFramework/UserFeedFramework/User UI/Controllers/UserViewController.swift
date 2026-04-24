//
//  FeedViewController.swift
//  UserFeedFramework
//
//  Created by Dimitra Malliarou on 24/4/26.
//

import UIKit


public protocol UserViewControllerDelegate: AnyObject {
    func didRequestUserRefresher()
}

public final class UserViewController: UITableViewController, UITableViewDataSourcePrefetching, UserLoadingView, UserErrorView {
    public func display(_ viewModel: UserLoadingViewModel) {
        
    }
    
    public func display(_ viewModel: UserErrorViewModel) {
        
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    

    
}
