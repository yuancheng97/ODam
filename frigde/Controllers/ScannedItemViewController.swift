//
//  ScannedItemViewController.swift
//  frigde
//
//  Created by Tony Liao on 2019/3/30.
//  Copyright © 2019 GreatLL. All rights reserved.
//

import Foundation
import UIKit

//protocol ScannedItemDelegate {
//    func selectAnItem (item: String)
//}

class ScannedItemViewController: UIViewController, UITextFieldDelegate {
    
//    var delegate: ScannedItemDelegate?
    
    var items: [String]?
    var itemChosen: String?
    var itemInput: String?
    
    @IBOutlet weak var introduction: UILabel!
    @IBOutlet weak var Button0: UIButton!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var ButtonNotListed: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Button0.setTitle(items![0], for: .normal)
        Button1.setTitle(items![1], for: .normal)
        Button2.setTitle(items![2], for: .normal)
        
        Button0.layer.cornerRadius = 10
        Button1.layer.cornerRadius = 10
        Button2.layer.cornerRadius = 10
        ButtonNotListed.layer.cornerRadius = 10
        
    }
    
    @IBAction func hitButton0(_ sender: UIButton) {
        itemChosen = items![0]
//        print(itemChosen)
////        delegate?.selectAnItem(item: itemChosen!)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hitButton1(_ sender: UIButton) {
        itemChosen = items![1]
        
    }
    
    @IBAction func hitButton2(_ sender: UIButton) {
        itemChosen = items![2]
        
    }
    
    @IBAction func hitNotListed(_ sender: UIButton) {
        itemChosen = ""
    }
    
    
}


