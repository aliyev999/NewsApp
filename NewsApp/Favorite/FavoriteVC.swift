import UIKit

class FavoriteVC: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var newsList: [News] = []
    private var favoriteNewsList: [News] = []
    private let newsData = NewsData()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Добавляем refreshControl к superview collectionView, который является UIScrollView
        if let scrollView = collectionView.superview as? UIScrollView {
            scrollView.refreshControl = refreshControl
        }
        
        getData()
    }
    
    @objc private func refreshData() {
        getData()
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
        collectionView.reloadData()
        refreshControl.endRefreshing()
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
