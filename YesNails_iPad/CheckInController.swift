//
//  CheckInController.swift
//  YesNails_iPad
//
//  Created by brandon on 4/28/19.
//  Copyright © 2019 Brandon Nguyen. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AudioToolbox

class CheckInController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Navi.rightBarButtonItem?.isEnabled = false
        selectButton.isEnabled = false
        [nameField, phoneField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    // Make sure that both fields are entered before enabling "Select Services" button
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        } else {
            let nameText = nameField.text
            let phoneText = phoneField.text
            if (nameText?.isEmpty == false && phoneText?.isEmpty == false) {
//                self.Navi.rightBarButtonItem?.isEnabled = true
                selectButton.isEnabled = true
                return
            }
        }
//        Navi.rightBarButtonItem?.isEnabled = false
        selectButton.isEnabled = false
    }
    
    // When user taps outside of keyboard, the keyboard will disappear.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // TODO: Find a way to sort better in the firestore database, sort by documentID
    // TODO: The app will overwrite the data if its restarted. It will get buggy. The only fix is to delete everything in firestore before starting the app.
    @IBAction func unwindToRoot(segue: UIStoryboardSegue) {
        AudioServicesPlayAlertSound(1002)
        
//        Navi.rightBarButtonItem?.isEnabled = false
        selectButton.isEnabled = false
        // Send info to database before clearing
        guard let nameText = nameField.text, !nameText.isEmpty else { return }
        guard let phoneText = phoneField.text, !phoneText.isEmpty else { return }
        
    
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        
        let now = df.string(from: Date())
        
        let dataToSave: [String: Any] = ["dateEntered": now, "Name" : nameText, "Phone" : phoneText, "Services":appDelegate.selectedServices]
        // Used timestamp date to order by first-come-first-serve basis
        appDelegate.docRef?.document(now).setData(dataToSave)
        
        // Clear
        nameField.text = ""
        phoneField.text = ""
        appDelegate.selectedServices.removeAll()
        
        
    }
}
