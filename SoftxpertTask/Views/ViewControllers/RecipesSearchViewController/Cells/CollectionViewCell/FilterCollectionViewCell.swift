//
//  FilterCollectionViewCell.swift
//  SoftxpertTask
//
//  Created by Macbook on 27/01/2022.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filterLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //before selection
        filterLabel.alpha = 0.6
    }
    
    func setupCell(text: String) {
        filterLabel.text = text
    }
    
    override var isSelected: Bool {
        didSet{
            //in  selection make titleLabel.alpha = 1
            filterLabel.alpha = isSelected ? 1.0 : 0.6
        }
    }
}
