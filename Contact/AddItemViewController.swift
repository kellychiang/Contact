//
//  AddItemViewController.swift
//  Contact
//
//  Created by kelly on 2014/10/17.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController ,ContactSelectionDelegate {
    
    @IBOutlet weak var contactImageView: UIImageView! = UIImageView ()
    @IBOutlet weak var firstNameLabel: UILabel! = UILabel ()
    @IBOutlet weak var lastNameLabel: UILabel! = UILabel ()
    @IBOutlet weak var titleTextField: UITextField! = UITextField ()

    var contactIdentifierString: NSString = NSString ()
    var datePicker: NSDate = NSDate ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstNameLabel.text = "Your"
        lastNameLabel.text = "Contact"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneButton(sender: AnyObject) {
        
        let moc: NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        
        let predicate: NSPredicate = NSPredicate(format: "identifier == '\(contactIdentifierString)' ")!
        let results: NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(Contact), withPredicate: predicate, managedObjectContext: moc)
        let contact: Contact = results.lastObject as Contact
        
        let toDoItem: TodoItem = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(TodoItem), managedObjectConect: moc)
            as TodoItem
        
        toDoItem.identifier = "\(NSDate())"
        toDoItem.dueDate = datePicker
        toDoItem.note = titleTextField.text
        toDoItem.contact = contact
        
        SwiftCoreDataHelper.saveManagedObjectContext(moc)
        
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    func userDidSelectContact(contactIdentifier: NSString) {
        contactIdentifierString = contactIdentifier
    
        let moc: NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let predicate: NSPredicate = NSPredicate(format: "identifier == '\(contactIdentifier)' ")!
        let results: NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(Contact), withPredicate: predicate, managedObjectContext: moc)
        
        let contact: Contact = results.lastObject as Contact
        contactImageView.image = UIImage(data: contact.contactImageView)
        firstNameLabel.text = contact.firstName
        lastNameLabel.text = contact.lastName
    
    }

    
    @IBAction func pickChanged(sender: UIDatePicker) {
        
        datePicker = sender.date
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "contactSegue") {
            let viewController: ContactsTableViewController = segue.destinationViewController as ContactsTableViewController
            
            viewController.delegate = self
        }

    }
    

}
