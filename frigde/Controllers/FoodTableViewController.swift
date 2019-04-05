//
//  ViewController.swift
//  FridgeTest
//
//  Created by Iris Jiang on 3/30/19.
//  Copyright © 2019 Iris Jiang. All rights reserved.
//

import UIKit
import Firebase
import SwipeCellKit

class FoodTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var refFood: DatabaseReference!
    var inputMethod = ""
    var returnedFoodName = "initial"
    
    var array:[String] = ["apple","banana","orange","milk","pineapple","strawberry","watermelon","blueberry","coconut","grape","honeydew","lime","lemon","pear","peach","cherry","mango","kiwi", "egg","fish","yogurt","bean","carrot","cauliflower","cucumber","eggplant","lettuce","onion","tomato","potato","pea","pepper","pumpkin","spinach","pizza","grapefruit","citrus","salad","bacon","sausage","hamburger","fries","leftover","cheese","avocado","jam","juice","hot dog", "lunch", "dinner", "breakfast", "coffee", "drink", "salmon", "smoked salmon", "sashimi", "bread", "water", "bottled water", "meat", "mushroom", "sandwich", "coke", "soda", "sprite", "garlic", "taco", "burrito", "beef"]
    
    var dict:[String:Int] = [
        "apple":45,"banana":6,"orange":45,"milk":8,"pineapple":4,"strawberry":6,
        "watermelon":18,"blueberry":7,"coconut":14,"grape":8,"honeydew":14,"lime":45,
        "lemon":45,"pear":8,"peach":4,"cherry":7,"mango":10,"kiwi":14, "egg":24, "fish":1,
        "yogurt":8,"bean":7,"carrot":4,"cauliflower":14,"cucumber":7,"eggplant":18,
        "lettuce":7,"onion":45,"tomato":14,"potato":90,"pea":5,"pepper":14, "pumpkin":75,
        "spinach":6,"pizza":6,"grapefruit":14,"citrus":14,"salad":4,"hot dog":7,"bacon":7,
        "sausage":3,"hamburger":1,"fries":1,"leftover":4,"cheese":90,"avocado":4,"jam":365,"juice":90,
        "lunch":2,"dinner":2,"breakfast":2,"coffee":1,"drink":3,"salmon":2, "smoked salmon":7, "sashimi":1, "bread": 3, "water":10, "bottled water":10, "meat":2, "mushroom": 5, "sandwich":2, "coke":2, "soda":2,"sprite":2, "garlic":10, "taco":1, "burrito":1, "beef":2
    ]
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldExp: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tblFood: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var foodList = [FoodModel]()
    
    //actions when an item in the list is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let food = foodList[indexPath.row]
        
        let alertController = UIAlertController(title:food.name?.uppercased(), message:"Please modify your entry here", preferredStyle:.alert)
        
        let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
            let id = food.id
            let name = alertController.textFields?[0].text
            let exp = alertController.textFields?[1].text
            
            self.updateFood(id: id!, name: name!, exp: exp!)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style:.default){(_) in
            self.deleteFood(id: food.id!, name: food.name!)
        }
        alertController.addTextField{(textField) in
            textField.text = food.name
        }
        
        alertController.addTextField{(textField) in
            textField.text = food.exp
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion:nil)
    }
    
    //update and delete food
    func updateFood(id: String, name: String, exp: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let food = [
            "id": id,
            "foodName":name,
            "foodExp":exp,
            "date":formatter.string(from: Date())
        ]
        refFood.child(id).setValue(food)
        labelMessage.text = "Food Info Updated."
    }
    
    func deleteFood(id:String, name:String){
        refFood.child(id).setValue(nil)
        labelMessage.text = "\(name) Deleted."
    }
    
    //tableview protocol functions
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) ->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        let food: FoodModel
        
        cell.delegate = self
        
        
        food = foodList[indexPath.row]
        cell.lblName.text = food.name?.lowercased()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        guard let newFoodDate = formatter.date(from: food.date!) else {
            fatalError()
        }
        
        let now = Date()
        let components = Calendar.current.dateComponents([.day], from: newFoodDate,to: now)
        
        if let mexp = food.exp {
            if isStringAnInt(string: mexp) {
                let dif = Int(food.exp!)! - components.day!
                if dif >= 0 {
                    cell.lblExp.text = String(dif) + " days"
                }
                if dif == 0 {
                    //create an alarm
                    let alert = UIAlertController(title: "Sad News", message: "ODam!\n \(food.name!.uppercased()) is dying!\n Take it out!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.deleteFood(id: food.id!, name: food.name!)
                }
            }
        }
        return cell
    }
    
    //Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldName.delegate = self
        self.textFieldExp.delegate = self
        
        confirmButton.layer.cornerRadius = 10
                
        FirebaseApp.configure()
        refFood = Database.database().reference().child("food");
        refFood.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount >= 0{
                self.foodList.removeAll()
                
                for foods in snapshot.children.allObjects as![DataSnapshot]{
                    let foodObject = foods.value as? [String: AnyObject]
                    let foodName = foodObject?["foodName"]
                    let foodExp = foodObject?["foodExp"]
                    let foodId = foodObject?["id"]
                    let foodDate = foodObject?["date"]
                    let food = FoodModel (id: foodId as! String?,
                                          name: foodName as! String?,
                                          exp: foodExp as! String?,
                                          date: foodDate as! String?)
                    self.foodList.append(food)
                }
                self.tblFood.reloadData()
            }
        })
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }

    // when confirm is pressed
    @IBAction func buttonAddFood(_ sender: UIButton) {
        addFood()
        textFieldExp.text = ""
        if labelMessage.text != "Cannot Find Expiration Date" {
            textFieldName.text = ""
        }
        
    }
    
    func addFood(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let key = refFood.childByAutoId().key
       
        if (textFieldName.text == ""){
            labelMessage.text = "No Food Added"
        }
        else {
            if (textFieldExp.text == ""){
                // run dictionary and change foodExp to dict(foodName)
                
                if array.contains(textFieldName.text!.lowercased()){
                    // then the expiration date is the matched value getting from dict
                    let pred_exp = dict[textFieldName.text!.lowercased()]
                    let food = ["id":key,
                                "foodName":textFieldName.text! as String,
                                "foodExp": String(pred_exp!) as String,
                                "date":formatter.string(from: Date()) as String
                    ]
                    refFood.child(key!).setValue(food)
                    labelMessage.text = "\(textFieldName.text!) Added"
                }
                else {
                    labelMessage.text = "Cannot Find Expiration Date"
                }
            }
                
            else {
                let food = ["id":key,
                            "foodName":textFieldName.text! as String,
                            "foodExp":textFieldExp.text! as String,
                            "date":formatter.string(from: Date()) as String]
                refFood.child(key!).setValue(food)
                labelMessage.text = "\(textFieldName.text!) Added"
                if !array.contains(textFieldName.text!.lowercased()){
                     array.append(textFieldName.text!.lowercased())
                }
                dict[textFieldName.text!.lowercased()] = Int(textFieldExp.text!)
            }
        }
    }
        
//        if (textFieldName.text == ""){
//            labelMessage.text = "No Food Added"
//        }
//        else {
//            if array.contains(textFieldName.text!.lowercased()){
//                // then the expiration date is the matched value getting from dict
//                let pred_exp = dict[textFieldName.text!.lowercased()]
//                let food = ["id":key,
//                            "foodName":textFieldName.text! as String,
//                            "foodExp": String(pred_exp!) as String,
//                            "date":formatter.string(from: Date()) as String
//                ]
//                refFood.child(key!).setValue(food)
//                labelMessage.text = "\(textFieldName.text!) Added"
//            }
//            else {
//                labelMessage.text = "Cannot Find Expiration Date"
//            }
//
//        }
//        else {
//            let food = ["id":key,
//                        "foodName":textFieldName.text! as String,
//                        "foodExp":textFieldExp.text! as String,
//                        "date":formatter.string(from: Date()) as String]
//            refFood.child(key!).setValue(food)
//            labelMessage.text = "\(textFieldName.text!) Added"
//        }
//        }
//
        
    
    
    // when camera is pressed
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
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
    
    //segue prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPhoto" {
            let destinationVC = segue.destination as! CameraViewController
            destinationVC.passedInputMethod = inputMethod
        }
//        if segue.identifier == "tableToItems" {
//            let destinationVC1 = segue.destination as! ScannedItemViewController
//            destinationVC1.delegate = self
//        }
        
    }
    
    //scanneditem protocol function
//    func selectAnItem(item: String) {
//        print(item)
//    }
    
    @IBAction func unwindToThisViewController(_ sender: UIStoryboardSegue) {
        if sender.source is ScannedItemViewController {
            if let senderVC = sender.source as? ScannedItemViewController {
                returnedFoodName = senderVC.itemChosen!
            }
        }
        textFieldName.text = returnedFoodName
    }
    
    //text field return
    func textFieldShouldReturn(_ textFieldExp: UITextField) -> Bool {
        textFieldExp.resignFirstResponder()
        return true
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.textFieldExp.resignFirstResponder()
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    
}

//swipe cell delegate methods
extension FoodTableViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Throw It Away!") { action, indexPath in
            // handle action by updating model with deletion
            let food = self.foodList[indexPath.row]
            self.deleteFood(id: food.id!, name: food.name!)
            
        }
        
        return [deleteAction]
    }
    
    
}

