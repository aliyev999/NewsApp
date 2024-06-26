import Foundation

class NewsData {
    private let fileName = "news"
    private let favoritesFileName = "favorites.json"
    private var favorites: [Favorite] = []
    
    func getNews(news: inout [News]) {
        if let file = Bundle.main.url(forResource: self.fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                news = try JSONDecoder().decode([News].self, from: data)
            } catch {
                print("Failed to decode news data:", error.localizedDescription)
            }
        } else {
            print("News JSON file not found.")
        }
    }
    
    
}
