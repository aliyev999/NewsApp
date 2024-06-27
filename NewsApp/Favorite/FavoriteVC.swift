import UIKit

class FavoriteVC: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var newsList: [News] = []
    private var favoriteNewsList: [News] = []
    private let newsData = NewsData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UserDefaults.standard.bool(forKey: "loggedIn") {
            let controller = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            navigationController?.show(controller, sender: nil)
        } else {
            getData()
        }
    }
    
    // Fetch favorite news items
    private func getData() {
        newsData.getNews(news: &newsList)
        guard let loggedInUserID = UserDefaults.standard.string(forKey: "loggedInUserID") else {
            print("Logged in user ID not found.")
            return
        }
        
        let favorites = newsData.getFavorites(userId: loggedInUserID)
        favoriteNewsList.removeAll()
        
        for favorite in favorites {
            for newsId in favorite.news {
                if let news = newsList.first(where: { $0.id == newsId }) {
                    favoriteNewsList.append(news)
                }
            }
        }
        print(favoriteNewsList)
        collectionView.reloadData()
    }
    
}

// CollectionView Settings
extension FavoriteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteNewsList.count
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
        return CGSize(width: collectionView.frame.width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
        controller.selectedNews = favoriteNewsList[indexPath.row]
        navigationController?.show(controller, sender: nil)
    }
}
