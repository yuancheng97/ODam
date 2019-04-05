//
//  foodCell.swift
//  frigde
//
//  Created by Tony Liao on 2019/3/30.
//  Copyright © 2019 GreatLL. All rights reserved.
//

import Foundation
import UIKit

class foodfile {
    var image: UIImage
    var title: String
    var boughtdate: String
    //let dateFormatter = DateFormatter()
    
    //dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    //convertedDate = dateFormatter.stringFromDate(currentDate)
    
    init(image: UIImage, title: String, boughtdate: String){
        self.image = image
        self.title = title
        self.boughtdate = boughtdate
    }
}
