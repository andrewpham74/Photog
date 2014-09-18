//
//  SearchViewController.swift
//  Photog
//
//  Created by One Month on 9/17/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate
{
    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var tableView: UITableView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        searchBar.text = ""
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        
        var searchTerm = searchBar.text
        
        NetworkManager.sharedInstance.findUsers(searchTerm, completionHandler: {
            (objects, error) -> () in
            
            println(objects)
            println(error)
            
        })
    }
    
}
