//
//  TodoItem.swift
//  Contact
//
//  Created by kelly on 2014/10/17.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import Foundation
import CoreData

@objc (TodoItem)
class TodoItem: NSManagedObject {

    @NSManaged var dueDate: NSDate
    @NSManaged var identifier: String
    @NSManaged var note: String
    @NSManaged var contact: Contact

}
