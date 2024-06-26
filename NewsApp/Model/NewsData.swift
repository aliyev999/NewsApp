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
    
    func addFavorite(userId: String, newsId: String) {
        if let index = favorites.firstIndex(where: { $0.id == userId }) {
            if !favorites[index].news.contains(newsId) {
                favorites[index].news.append(newsId)
                saveFavorites()
            } else {
                print("News with id \(newsId) is already in favorites for user \(userId).")
            }
        } else {
            // User not found in favorites, create a new entry
            let newFavorite = Favorite(id: userId, news: [newsId])
            favorites.append(newFavorite)
            saveFavorites()
        }
    }
    
    func removeFavorite(userId: String, newsId: String) {
        if let index = favorites.firstIndex(where: { $0.id == userId }) {
            favorites[index].news = favorites[index].news.filter { $0 != newsId }
            saveFavorites()
        }
    }
    
    func isFavorite(userId: String, newsId: String) -> Bool {
        if let index = favorites.firstIndex(where: { $0.id == userId }) {
            return favorites[index].news.contains(newsId)
        }
        return false
    }
    
    func addFavoritesNews(userId: String, news: News) {
        guard let newsId = news.id else {
            print("News id is missing.")
            return
        }
        
        if isFavorite(userId: userId, newsId: newsId) {
            removeFavorite(userId: userId, newsId: newsId)
        } else {
            addFavorite(userId: userId, newsId: newsId)
        }
    }
    
    func getAllFavorites() -> [Favorite] {
        return favorites
    }
    
    private func saveFavorites() {
        guard let fileURL = getFavoritesFileURL() else {
            print("Failed to get file URL for saving favorites.")
            return
        }
        
        do {
            let data = try JSONEncoder().encode(favorites)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save favorites:", error.localizedDescription)
        }
    }
    
    private func loadFavorites() {
        guard let fileURL = getFavoritesFileURL() else {
            print("Failed to get file URL for loading favorites.")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            favorites = try JSONDecoder().decode([Favorite].self, from: data)
        } catch {
            print("Failed to load favorites:", error.localizedDescription)
        }
    }
    
    private func getFavoritesFileURL() -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to access document directory.")
            return nil
        }
        return url.appendingPathComponent(favoritesFileName)
    }
}
