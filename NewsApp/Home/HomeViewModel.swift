import Foundation

class HomeViewModel {
    var newsList: [News] = []
    var filteredNewsList: [News] = []
    
    var callback: (() -> Void)?
    
    func getData() {
        let newsData = NewsData()
        newsData.getNews(news: &newsList)
        filteredNewsList = newsList
        callback?()
    }
    
    func filterDataByCategory(_ category: Category?) {
        filteredNewsList = newsList.filter { $0.category?.rawValue == category?.rawValue }
        callback?()
    }
    
    func resetFilter() {
        filteredNewsList = newsList
        callback?()
    }
}
