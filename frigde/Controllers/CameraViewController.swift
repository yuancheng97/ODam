//
//  ViewController.swift
//  frigde
//
//  Created by Tony Liao on 2019/3/29.
//  Copyright © 2019 GreatLL. All rights reserved.
//

import UIKit
import Vision
import SwiftyJSON

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var img: UIImage?
    let session = URLSession.shared
    var passedInputMethod = ""
    var tags: [String] = []
    
    var googleAPIKey = "AIzaSyBnx4464fDq4YOMG6Xhy64NdiKRG8wctHA"
    lazy var googleURL = "https://vision.googleapis.com/v1/images:annotate?key="+googleAPIKey
    @IBOutlet weak var photo: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if passedInputMethod == "camera" {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
        }
        else if passedInputMethod == "photo library" {
            print("photo library")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
        }
        
        
        present(imagePicker, animated: true, completion: nil)
    
        confirmButton.layer.cornerRadius = 12
    }

    //pick image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photo.image = userPickedImage
            img = userPickedImage
        }
        
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
//        confirmButton.isEnabled = false
        
        let imageData:Data = img!.jpegData(compressionQuality: 0.2)!
        let imageStr = imageData.base64EncodedString()
        
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageStr
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 3
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        let googleurl = URL(string: googleURL)
        var request = URLRequest(url: googleurl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        request.httpBody = data
        
        let semaphore = DispatchSemaphore(value: 0)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            
            
            self.analyze(data!)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        
        
        performSegue(withIdentifier: "goToTags", sender: self )
        
    }

    func analyze(_ dataToParse: Data){
        let json = JSON(dataToParse)
        print(json)
        let responses: JSON = json["responses"][0]
        print(responses)
        let labelAnnotations: JSON = responses["labelAnnotations"]
        let numLabels: Int = labelAnnotations.count
        if numLabels > 0 {
            var labelResultsText:String = "Labels found: "
            for index in 0..<numLabels {
                let label = labelAnnotations[index]["description"].stringValue
                tags.append(label)
                print(tags[index])
            }
        } else {
            print("No Labels Found")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        sleep(2)
        print("This is prepare")
        if segue.identifier == "goToTags"{
            let destinationVC = segue.destination as! ScannedItemViewController
            destinationVC.items = tags
        }
    }
   
}

