//
//  ViewController.swift
//  YesNails_iPad
//
//  Created by brandon on 4/27/19.
//  Copyright © 2019 Brandon Nguyen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let cellId = "cellId"
    
    let services = [
        "Acrylic Nails", "Natural Nails", "Dipping", "Additional Services"
    ]
    
    let acrylicNailsServices = [
        "Full Set", "Full Set with Gel", "Fill", "Fill with Gel Color", "Pink & White", "Fill Pink & White"
    ]
    
    let naturalNailsServices = [
        "Regular Manicure", "Manicure with Gel Color", "Gel Color", "French Gel", "Pedicure", "Pedicure with Sugar Scrub", "Deluxe Pedicure"
    ]
    
    let dippingServices = [
        "Natural Nails", "Artificial Tip"
    ]
    
    let additionalServices = [
        "Regular Color Change", "Gel Color Change"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        appDelegate.selectedServices.removeAll() // Prevents duplicate when going back to fix contact info
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return services.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = services[section]
        label.textColor = UIColor.white
        label.font = label.font.withSize(30)
        label.backgroundColor = UIColor.red
        return label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch(section) {
        case 0:
            rows = acrylicNailsServices.count
        case 1:
            rows = naturalNailsServices.count
        case 2:
            rows = dippingServices.count
        case 3:
            rows = additionalServices.count
        default:
            break
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        var serviceName = ""
        
        switch (indexPath.section) {
        case 0:
            serviceName = acrylicNailsServices[indexPath.row]
        case 1:
            serviceName = naturalNailsServices[indexPath.row]
        case 2:
            serviceName = dippingServices[indexPath.row]
        case 3:
            serviceName = additionalServices[indexPath.row]
        default:
            break
        }
        
        cell.textLabel?.text = serviceName
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedServiceName = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        if (tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
//            print ("Deselected \(tableView.cellForRow(at: indexPath)?.textLabel?.text)")
            appDelegate.selectedServices.removeAll {$0 == selectedServiceName}
        } else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//            print ("Selected \(tableView.cellForRow(at: indexPath)?.textLabel?.text)")
            appDelegate.selectedServices.append(selectedServiceName)
        }
        
//        print ("Current Services")
//        for service in appDelegate.selectedServices {
//            print (service)
//        }
    }
    
}
