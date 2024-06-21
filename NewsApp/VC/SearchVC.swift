//
//  SearchVC.swift
//  NewsApp
//
//  Created by AS on 21.06.24.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarConfigure()
    }
    
    private func searchBarConfigure() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
}
