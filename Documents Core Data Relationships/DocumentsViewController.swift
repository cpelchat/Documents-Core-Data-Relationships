//
//  DocumentsViewController.swift
//  Documents Core Data Relationship
//
//  Created by Cassidy Pelchat on 9/27/19.
//  Copyright © 2019 Cassidy Pelchat. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var documentsTableView: UITableView!
    
    var category: Category?
    var documents = [Document]()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category?.name ?? ""
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDocumentsArray()
        documentsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateDocumentsArray() {
        documents = category?.documents?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as? [Document] ?? [Document]()
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        let document = documents[indexPath.row]
        
        if let managedObjectContext = document.managedObjectContext {
            managedObjectContext.delete(document)
            
            do {
                try managedObjectContext.save()
                self.documents.remove(at: indexPath.row)
                documentsTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                alertNotifyUser(message: "Delete failed.")
                documentsTableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let cell = cell as? DocumentTableViewCell {
            let document = documents[indexPath.row]
            cell.nameLabel.text = document.name
            cell.sizeLabel.text = String(document.size)
            if let modifiedDate = document.modifiedDate {
                cell.modifiedDateLabel.text = dateFormatter.string(from: modifiedDate)
            } else {
                cell.modifiedDateLabel.text = "unknown"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.deleteDocument(at: indexPath)
        }
        
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentViewController,
            let segueIdentifier = segue.identifier {
            destination.category = category
            if (segueIdentifier == "existingDocument") {
                if let row = documentsTableView.indexPathForSelectedRow?.row {
                    destination.document = documents[row]
                }
            }
        }
    }
    
}
