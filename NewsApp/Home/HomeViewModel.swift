//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by AS on 21.06.24.
//

import Foundation

class HomeViewModel {
    var newsList: [News] = []
    
    var callback: (() -> Void)?
    //Get news list
    func getData() {
        let news = NewsData()
        news.getNews(news: &newsList)
        callback?()
    }
}
