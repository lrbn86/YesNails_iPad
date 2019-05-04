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

class CheckInController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var Navi: UINavigationItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Navi.rightBarButtonItem?.isEnabled = false
        
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
                self.Navi.rightBarButtonItem?.isEnabled = true
                return
            }
        }
        Navi.rightBarButtonItem?.isEnabled = false
    }
    
    // When user taps outside of keyboard, the keyboard will disappear.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // TODO: Find a way to sort better in the firestore database, sort by documentID
    // TODO: The app will overwrite the data if its restarted. It will get buggy. The only fix is to delete everything in firestore before starting the app.
    @IBAction func unwindToRoot(segue: UIStoryboardSegue) {
        
//        let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//            NSLog("The \"OK\" alert occured.")
//        }))
        
        Navi.rightBarButtonItem?.isEnabled = false
        
        // Send info to database before clearing
        guard let nameText = nameField.text, !nameText.isEmpty else { return }
        guard let phoneText = phoneField.text, !phoneText.isEmpty else { return }
        appDelegate.customerID += 1;
        // TODO: Add a field to the data passed such as "Ready"
        // So the iPad will alert when iPhone modifies the "ready" field
        // Repeatedly check for "ready" status
        let dataToSave: [String: Any] = ["ID": appDelegate.customerID, "Name" : nameText, "Phone" : phoneText, "Services":appDelegate.selectedServices]
        // Customized documentID so that it follows the first-come-first-serve ordering
        appDelegate.docRef?.document(String(appDelegate.customerID)).setData(dataToSave)
        let utterance = AVSpeechUtterance(string: "Thank you for choosing us, \(nameText).")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
        
        // Clear
        nameField.text = ""
        phoneField.text = ""
        appDelegate.selectedServices.removeAll()
//        self.present(alert, animated: true, completion: nil)
    }
    
}
