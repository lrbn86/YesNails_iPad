//
//  CheckInController.swift
//  YesNails_iPad
//
//  Created by brandon on 4/28/19.
//  Copyright © 2019 Brandon Nguyen. All rights reserved.
//

import UIKit
import Firebase

class CheckInController: UIViewController {
    
    var docRef: CollectionReference?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().collection("Customers")
    }
    @IBAction func unwindToRoot(segue: UIStoryboardSegue) {
        
        // Send info to database before clearing
        
        // Send in name
        guard let nameText = nameField.text, !nameText.isEmpty else { return }
        guard let phoneText = phoneField.text, !phoneText.isEmpty else { return }
        let dataToSave: [String: Any] = ["Name" : nameText, "Phone" : phoneText, "Services":appDelegate.selectedServices]
        docRef?.addDocument(data: dataToSave)
//        docRef.setData(dataToSave) { (error) in
//            if let erro = error {
//                print ("O NO")
//            } else {
//                print ("Saved!")
//            }
//
//        }
        // Send in phone number
        // Send in array of services selected
        print ("Just sent in the selected services: ")
        for service in appDelegate.selectedServices {
            print (service)
        }
        nameField.text = ""
        phoneField.text = ""
        
    }
}
