//
//  ViewController.swift
//  notifWithCloudKit
//
//  Created by Michael Varian Sutanto on 19/08/19.
//  Copyright © 2019 Michael Varian Sutanto. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func saveButton(_ sender: Any) {
        save(name : name.text!)
    }
    
    @IBAction func fetchAction(_ sender: Any) {
        retrieve()
        
    }
    
    
    let database = CKContainer.default().privateCloudDatabase
    
    var record = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        name.delegate = self
    }

    func save(name:String){
        let newName = CKRecord(recordType:"Data")
        
        newName.setValue(name, forKey: "String")
        
        database.save(newName){
            (record, error) in
            guard record != nil else {return}
            print("Success")
        }
    }

    func retrieve(){
        let query = CKQuery(recordType: "Data", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) {(records, error) in
            guard let records = records else {return}
            
            let sortRecords = records.sorted(by: {$0.creationDate! < $1.creationDate!})
            
            self.record = sortRecords
            print(self.record)
            
            DispatchQueue.main.async {
                let name = self.record.last?.value(forKey: "String") as? String
                self.nameLabel.text = name
            }
           
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        //or
        //self.view.endEditing(true)
        
        return true
    }
}

