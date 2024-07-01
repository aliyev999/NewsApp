import UIKit

class CategoriesCell: UICollectionViewCell {
    
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.view.backgroundColor = UIColor(named: "firstColor")
    }
    
    private func setupUI() {
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }
    
    func setupTitle(title: String) {
        categoryLabel.text = title
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = .systemBlue
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = UIColor(named: "firstColor")
            }
        }
    }
}
