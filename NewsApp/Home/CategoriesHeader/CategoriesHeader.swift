import UIKit

class CategoriesHeader: UICollectionReusableView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var selectedIndexPath: IndexPath?
    var selectedCallback: ((Category?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "\(CategoriesCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(CategoriesCell.self)")
    }
}

extension CategoriesHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoriesCell.self)", for: indexPath) as! CategoriesCell
        let category = Category.allCases[indexPath.item]
        cell.setupTitle(title: category.rawValue)
        
        if let selectedIndexPath = selectedIndexPath, indexPath == selectedIndexPath {
            cell.setSelected(true)
        } else {
            cell.setSelected(false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = Category.allCases[indexPath.item]
        let cellWidth = calculateWidth(for: category)
        return CGSize(width: cellWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        collectionView.reloadData()
        selectedCallback?(selectedIndexPath.map { Category.allCases[$0.item] })
    }
    
    private func calculateWidth(for category: Category) -> CGFloat {
        let title = category.rawValue
        let font = UIFont.systemFont(ofSize: 18)
        let width = title.size(withAttributes: [.font: font]).width + 24
        return width
    }
}
