import UIKit

class FavoriteVC: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private var favView: UIView!
    @IBOutlet private weak var warningLabel: UILabel!
    
    private var newsList: [News] = []
    private var favoriteNewsList: [News] = []
    private let newsData = NewsData()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupUI()
    }
    
    @objc
    private func refreshData() {
        getData()
        refreshControl.endRefreshing()
    }
    
    private func setupUI() {
        setupConstraints()
        
        refreshControl.addTarget(self, action: #selector(FavoriteVC.refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Update favorites", attributes: nil)
        refreshControl.tintColor = UIColor(named: "firstColor")
        
        collectionView.refreshControl = refreshControl
    }
    
    private func setupConstraints() {
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalConstraint = NSLayoutConstraint(item: warningLabel!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        view.addConstraint(verticalConstraint)
        
        let horizontalConstraint = NSLayoutConstraint(item: warningLabel!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        view.addConstraint(horizontalConstraint)
    }
    
    // Fetch favorite news items
    private func getData() {
        newsData.getNews(news: &newsList)
        guard let loggedInUserID = UserDefaults.standard.string(forKey: "loggedInUserID") else {
            print("Logged in user ID not found.")
            collectionView.isHidden = true
            warningLabel.isHidden = false
            return
        }
        
        collectionView.isHidden = false
        warningLabel.isHidden = true

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
