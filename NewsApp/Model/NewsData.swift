import Foundation

class NewsData {
    private let fileName = "news"
    private let favoritesFileName = "favorites.json"
    private var favorites: [Favorite] = []
    
    private var favoritesFileURL: URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsURL.appendingPathComponent(favoritesFileName)
    }
    
    func getNews(news: inout [News]) {
        if let file = Bundle.main.url(forResource: self.fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                news = try JSONDecoder().decode([News].self, from: data)
            } catch {
                print("Failed to decode news data:", error.localizedDescription)
            }
        }
    }
    
    func getFavorites() -> [Favorite] {
        guard let fileURL = favoritesFileURL else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let favorites = try JSONDecoder().decode([Favorite].self, from: data)
            self.favorites = favorites
            return favorites
        } catch {
            print("Failed to decode favorites data:", error.localizedDescription)
            return []
        }
    }
    
    func getFavorites(userId: String) -> [Favorite] {
        guard let fileURL = favoritesFileURL else {
            return []
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let favorites = try JSONDecoder().decode([Favorite].self, from: data)
            let userFavorites = favorites.filter { $0.id == userId }
            return userFavorites
        } catch {
            print("Failed to decode favorites data:", error.localizedDescription)
            return []
        }
    }
    
    func addFavorite(userId: String, newsId: String) {
        if let index = favorites.firstIndex(where: { $0.id == userId }) {
            var favorite = favorites[index]
            if !favorite.news.contains(newsId) {
                favorite.news.append(newsId)
                favorites[index] = favorite
                saveFavorites()
            }
        } else {
            let favorite = Favorite(id: userId, news: [newsId])
            favorites.append(favorite)
            saveFavorites()
        }
    }
    
    func removeFavorite(userId: String, newsId: String) {
        if let index = favorites.firstIndex(where: { $0.id == userId }) {
            var favorite = favorites[index]
            if let indexOfNews = favorite.news.firstIndex(of: newsId) {
                favorite.news.remove(at: indexOfNews)
                if favorite.news.isEmpty {
                    favorites.remove(at: index)
                } else {
                    favorites[index] = favorite
                }
                saveFavorites()
            }
        }
    }
    
    private func saveFavorites() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(favorites)
            guard let fileURL = favoritesFileURL else {
                return
            }
            try data.write(to: fileURL)
        } catch {
            print("Failed to encode or save favorites data:", error.localizedDescription)
        }
    }
    
    func isFavorite(userId: String, newsId: String) -> Bool {
        let favorites = getFavorites()
        if let favorite = favorites.first(where: { $0.id == userId }) {
            return favorite.news.contains(newsId)
        }
        return false
    }
}
