//
//  MenuCell.swift
//  NewsApp
//
//  Created by AS on 09.06.24.
//

import UIKit

class MenuCell: UITableViewCell {

    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
