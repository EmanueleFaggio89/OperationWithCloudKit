//
//  ViewController.swift
//  OperationWithCloudKit
//
//  Created by Emanuele Faggio on 01/04/2020.
//  Copyright © 2020 Emanuele Faggio. All rights reserved.
//

import UIKit
import CloudKit
import Foundation


class ViewController: UIViewController {
    
    var titles = [String]()
    var recordIDs = [CKRecord.ID]()
    var privateDatabase =  CKContainer.default().privateCloudDatabase
    
    @IBOutlet weak var TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        let title = TextField.text!
        let record = CKRecord(recordType: "RecordName")
        
        record.setValue(title, forKey: "title")
        
        privateDatabase.save(record) { (savedRecord, error) in
            if error == nil { print("Record saved")  }
            else { print("Record not saved.. \(error?.localizedDescription)") }
        }
    }
    
    
    
    
    
    
    @IBAction func retrieveBtn(_ sender: Any) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Strings", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        
        titles.removeAll()
        recordIDs.removeAll()
        
        operation.recordFetchedBlock = { record in
            self.titles.append(record["title"]!)
            self.recordIDs.append(record.recordID)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            
            DispatchQueue.main.async {
                
                print("Titles: \(self.titles)\n")
                print("RecordIDs: \(self.recordIDs)\n")
            }
            
            
        }
        
        privateDatabase.add(operation)
    }
    
    
    @IBAction func deleteBtn(_ sender: Any) {
    }
    @IBAction func updateBtn(_ sender: Any) {
    }
    
}

