//
//  SearchVC.swift
//  NewsApp
//
//  Created by AS on 21.06.24.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var searchResult: String?
    private var newsList: [News] = []
    private var filteredNewsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        searchBarConfigure()
        getData()
    }
    
    private func searchBarConfigure() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    private func getData() {
        let news = NewsData()
        news.getNews(news: &newsList)
    }
}

//SearchBar Settings
extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredNewsList = []
        } else {
            //Sual
            filteredNewsList = newsList.filter { $0.header!.lowercased().contains(searchText.lowercased()) }
        }
        
        //CollectionView Search animation
        collectionView.performBatchUpdates({
            collectionView.reloadSections(IndexSet(integer: 0))
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
}

//CollectionView Settings
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredNewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let newsItem = filteredNewsList[indexPath.row]
        cell.newsHeader.text = newsItem.header
        cell.newsText.text = newsItem.text
        cell.newsImage.image = UIImage(named: newsItem.image ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller =  storyboard?.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
        controller.selectedNews = newsList[indexPath.row]
        navigationController?.show(controller, sender: nil)
    }
}
