import UIKit

class NewsDetailVC: UIViewController {
    
    @IBOutlet private weak var readingTimeLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var header: UILabel!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var category: UILabel!
    
    var selectedNews: News?
    let newsData = NewsData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStarButtonAppearance()
    }
    
    private func setupUI() {
        addStarButton()
        readingTimeLabel.text = "\(calculateReadingTime(for: textView.text, wordsPerMinute: 200)) min"
        currentNews()
    }
    
    private func currentNews() {
        textView.text = selectedNews?.text
        header.text = selectedNews?.header
        date.text = selectedNews?.date
        if let currentAuthor = selectedNews?.author {
            author.text = "Published by: \(currentAuthor)"
        }
        image.image = UIImage(named: selectedNews?.image ?? "")
        category.text = selectedNews?.category?.rawValue
    }
    
    func calculateReadingTime(for text: String, wordsPerMinute: Int = 200) -> Int {
        let words = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        let wordCount = words.count
        let readingTime = Int(ceil(Double(wordCount) / Double(wordsPerMinute)))
        return readingTime
    }
    
    private func updateStarButtonAppearance() {
        guard let userId = UserDefaults.standard.string(forKey: "loggedInUserID"),
              let newsId = selectedNews?.id else {
            addStarButton()
            return
        }

        let isFav = newsData.isFavorite(userId: userId, newsId: newsId)
        if isFav {
            addStarFillButton()
        } else {
            addStarButton()
        }
    }

    @objc private func starButtonTapped() {
        guard let userId = UserDefaults.standard.string(forKey: "loggedInUserID"),
              let newsId = selectedNews?.id else {
            showLoginAlert()
            return
        }

        if newsData.isFavorite(userId: userId, newsId: newsId) {
            newsData.removeFavorite(userId: userId, newsId: newsId)
        } else {
            newsData.addFavorite(userId: userId, newsId: newsId)
        }
        updateStarButtonAppearance()
    }
    
    private func showLoginAlert() {
        let alert = UIAlertController(title: "Login Required", message: "Please log in to add this news to favorites.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// Star button extension
extension NewsDetailVC {
    private func addStarButton() {
        let starImage = UIImage(systemName: "star")
        let starButton = UIBarButtonItem(image: starImage, style: .plain, target: self, action: #selector(starButtonTapped))
        navigationItem.rightBarButtonItem = starButton
    }
    
    private func addStarFillButton() {
        let starImage = UIImage(systemName: "star.fill")
        let starButton = UIBarButtonItem(image: starImage, style: .plain, target: self, action: #selector(starButtonTapped))
        navigationItem.rightBarButtonItem = starButton
    }
}
