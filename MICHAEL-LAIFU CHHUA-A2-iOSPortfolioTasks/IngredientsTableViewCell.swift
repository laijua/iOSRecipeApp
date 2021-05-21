//
//  IngredientsTableViewCell.swift
//  MICHAEL-LAIFU CHHUA-A2-iOSPortfolioTasks
//
//  Created by Michael-Laifu Chhua on 6/4/21.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {
    // custom table view cell for the ingredients section of Create/Edit Meal table view controller

    @IBOutlet weak var ingredientLabel: UILabel!
    
    @IBOutlet weak var measurementLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
