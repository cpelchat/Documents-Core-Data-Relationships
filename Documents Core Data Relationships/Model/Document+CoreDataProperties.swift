//
//  Document+CoreDataProperties.swift
//  Documents Core Data Relationship
//
//  Created by Cassidy Pelchat on 9/27/19.
//  Copyright © 2019 Cassidy Pelchat. All rights reserved.
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var name: String?
    @NSManaged public var content: String?
    @NSManaged public var size: Int64
    @NSManaged public var rawModifiedDate: NSDate?
    @NSManaged public var category: Category?

}
