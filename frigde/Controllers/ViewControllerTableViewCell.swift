//
//  ViewControllerTableViewCell.swift
//  FridgeTest
//
//  Created by Iris Jiang on 3/30/19.
//  Copyright © 2019 Iris Jiang. All rights reserved.
//

import UIKit
import Firebase
import SwipeCellKit

class ViewControllerTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
