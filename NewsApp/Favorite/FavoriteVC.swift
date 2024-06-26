//
//  FavoriteVC.swift
//  NewsApp
//
//  Created by AS on 08.06.24.
//

import UIKit

class FavoriteVC: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var newsList: [News] = []
    private var favoriteNewsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Get news list
    private func getData() {
        _ = NewsData()
        //news.getNews(news: &newsList)
        //newsList = news.loadArticlesFromJSON()!
        collectionView.reloadData()
    }
    
    //Get favorite news
    
}

//CollectionView Settings
extension FavoriteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteNewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let newsItem = favoriteNewsList[indexPath.row]
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
