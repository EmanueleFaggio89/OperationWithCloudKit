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

var titles = [String]()
var recordIDs = [CKRecord.ID]()


class ViewController: UIViewController {
    
    
    var privateDatabase =  CKContainer.default().privateCloudDatabase
    
    @IBOutlet weak var TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        let title = TextField.text!
        let record = CKRecord(recordType: "Strings")
        
        record.setValue(title, forKey: "title")
        
        privateDatabase.save(record) { (savedRecord, error) in
            if error == nil { print("Record saved")  }
            else { print("Record not saved.. \(String(describing: error?.localizedDescription))") }
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
            titles.append(record["title"]!)
            recordIDs.append(record.recordID)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            
            DispatchQueue.main.async {
                
                print("Titles: \(titles)\n")
                print("RecordIDs: \(recordIDs)\n")
            }
            
            
        }
        
        privateDatabase.add(operation)
    }
    
    
    @IBAction func deleteBtn(_ sender: Any) {
        let recordID = recordIDs.first! // record ceh voglio eliminare
        
        privateDatabase.delete(withRecordID: recordID) { (deleteRecordId,error) in
            if error == nil { print("Record deleted") }
            else { print("Record doesnt deleted.. \(String(describing: error?.localizedDescription))")}
        }
        
    }
    
    
    
    
    
    @IBAction func updateBtn(_ sender: Any) {
        
        let newTitle = "New Title"
        let recordId = recordIDs.first!
        
        privateDatabase.fetch(withRecordID: recordId) { (record,error)  in
            if error == nil {
                record?.setValue(newTitle, forKey: "title")
                self.privateDatabase.save(record!, completionHandler: { (newRecord, error) in
                    if error == nil { print("Record Upload")}
                    else { print("error..\(String(describing: error?.localizedDescription))")}
                })
                
            }
            
        }
        
        
        
    }
    
}

