//
//  Recipe_TableViewCell.swift
//  Recipe Searcher
//
//  Created by MAC on 20/02/2022.
//

import UIKit

class Recipe_TableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeSource: UILabel!
    @IBOutlet weak var recipeHealthLabels: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
