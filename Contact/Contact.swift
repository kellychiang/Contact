//
//  Contact.swift
//  Contact
//
//  Created by kelly on 2014/10/17.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import Foundation
import CoreData

@objc (Contact)
class Contact: NSManagedObject {

    @NSManaged var contactImageView: NSData
    @NSManaged var email: String
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var identifier: String
    @NSManaged var phone: String
    @NSManaged var TodoItem: NSSet
 
}
