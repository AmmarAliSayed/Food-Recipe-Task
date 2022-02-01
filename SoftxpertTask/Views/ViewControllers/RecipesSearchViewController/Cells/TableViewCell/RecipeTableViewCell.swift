//
//  RecipeTableViewCell.swift
//  SoftxpertTask
//
//  Created by Macbook on 29/01/2022.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeHealthLabel: UILabel!
    @IBOutlet weak var recipeSourceLabel: UILabel!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = #colorLiteral(red: 0.09411764706, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = contentView.frame.size.width / 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //space between cells in table view
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

}
