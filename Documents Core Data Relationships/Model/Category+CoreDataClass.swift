//
//  Category+CoreDataClass.swift
//  Documents Core Data Relationship
//
//  Created by Cassidy Pelchat on 9/27/19.
//  Copyright © 2019 Cassidy Pelchat. All rights reserved.
//

import UIKit
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    
    convenience init?(name: String?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        self.init(entity: Category.entity(), insertInto: managedContext)
        self.name = name
    }
}
