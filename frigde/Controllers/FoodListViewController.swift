//
//  FoodListViewController.swift
//  frigde
//
//  Created by Tony Liao on 2019/3/30.
//  Copyright © 2019 GreatLL. All rights reserved.
//

import UIKit

class FoodListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var inputMethod = ""
    var foods: [foodfile] = []
    
    @IBOutlet weak var foodListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodListTableView.delegate = self
        foodListTableView.dataSource = self
        
        foods = createArray()
        
        //register custom cell
        foodListTableView.register(UINib(nibName: "foodTableViewCell", bundle: nil), forCellReuseIdentifier: "foodCell")

        //configure table view
        configureTableView()
        
        
    }
    
    func createArray() -> [foodfile] {
        
        var tempfoods: [foodfile] = []
        let newimage1 = UIImage(named: "garlic")
        let newimage2 = UIImage(named: "garlic")
        
        
        let food1 = foodfile(image:newimage1!,title: "milk", boughtdate: "2019.3.28")
        let food2 = foodfile(image:newimage2!,title: "garlic", boughtdate: "2019.2.28")
        
        tempfoods.append(food1)
        tempfoods.append(food2)
        
        return tempfoods
        
    }
    
    //protocol functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = foods[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as! foodTableViewCell
        cell.setFood(food: food)
        return cell
        
    }
    
    //configure table view
    func configureTableView() {
        foodListTableView.rowHeight = 80
    }
    

    //add a new item
    @IBAction func Add(_ sender: UIBarButtonItem) {
        //105
        let alert = UIAlertController(title: "Choose Input Method", message: nil, preferredStyle: .actionSheet)
        
        
        let useCamera = UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.inputMethod = "camera"
            self.performSegue(withIdentifier: "goToPhoto", sender: self)
        } )
        
        let usePhotoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.inputMethod = "photo library"
            self.performSegue(withIdentifier: "goToPhoto", sender: self)
        } )
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(useCamera)
        alert.addAction(usePhotoLibrary)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPhoto" {
            let destinationVC = segue.destination as! CameraViewController
            destinationVC.passedInputMethod = inputMethod
        }
    }
    
}
