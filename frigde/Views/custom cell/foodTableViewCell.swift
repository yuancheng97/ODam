//
//  foodTableViewCell.swift
//  frigde
//
//  Created by Tony Liao on 2019/3/30.
//  Copyright © 2019 GreatLL. All rights reserved.
//

import UIKit

class foodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var expirationDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFood(food: foodfile){
        foodImage.image = food.image
        foodName.text = food.title
        expirationDate.text = food.boughtdate
    }
    
}
