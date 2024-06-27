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
        print(newsData.getFavorites())
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
    
    private func calculateReadingTime(for text: String, wordsPerMinute: Int) -> Int {
        let words = text.split(whereSeparator: { !$0.isLetter })
        let wordCount = words.count
        return Int(ceil(Double(wordCount) / Double(wordsPerMinute)))
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
            return
        }

        if newsData.isFavorite(userId: userId, newsId: newsId) {
            newsData.removeFavorite(userId: userId, newsId: newsId)
        } else {
            newsData.addFavorite(userId: userId, newsId: newsId)
        }
        updateStarButtonAppearance()
    }
}

//Starbutton
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
