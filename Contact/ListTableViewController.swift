//
//  ListTableViewController.swift
//  Contact
//
//  Created by kelly on 2014/10/17.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ListTableViewController: UITableViewController , MFMessageComposeViewControllerDelegate , MFMailComposeViewControllerDelegate {

    var toDoItems: NSMutableArray = NSMutableArray ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.rowHeight = 160
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadData( )
    }
    
    func loadData( ) {
        toDoItems.removeAllObjects()
        
        let moc: NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let results: NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(TodoItem), withPredicate: nil, managedObjectContext: moc)
        
        if (results.count > 0){
            
            for toDo in results {
                let singleToDoItem: TodoItem = toDo as TodoItem
                
                let identifier = singleToDoItem.identifier
                
                let contact: Contact = singleToDoItem.contact
                
                let firstName = contact.firstName
                let lastName = contact.lastName
                let email = contact.email
                let phone = contact.phone
                
                let dueDate = singleToDoItem.dueDate
                let title = singleToDoItem.note
                
                let profileImage : UIImage = UIImage(data: contact.contactImageView)!
                let dic: NSDictionary = ["identifier"   :identifier,
                                         "firstName"    :firstName ,
                                         "lastName"     :lastName ,
                                         "email"        :email ,
                                         "phone"        :phone ,
                                         "dueDate"      :dueDate ,
                                         "title"        :title ,
                                         "profileImage" :profileImage]
                toDoItems.addObject(dic)
            }
            
            let dateDescriptor: NSSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
            let sortedArray: NSArray = toDoItems.sortedArrayUsingDescriptors([dateDescriptor])
            
            toDoItems = NSMutableArray(array: sortedArray)
            
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ListTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as ListTableViewCell

        // Configure the cell...
        
        let infoDic: NSDictionary = toDoItems.objectAtIndex(indexPath.row) as NSDictionary
        
        let firstName: NSString = infoDic.objectForKey("firstName") as NSString
        let lastName: NSString = infoDic.objectForKey("lastName") as NSString
        
        let dateFormatter: NSDateFormatter = NSDateFormatter ()
        dateFormatter.dateFormat = "MMMM dd"
        
        let dateString: NSString = dateFormatter.stringFromDate(infoDic.objectForKey("dueDate") as NSDate)
        
        cell.contactImageView.image = infoDic.objectForKey("profileImage") as UIImage
        cell.nameLabel.text = firstName + " " + lastName
        cell.titleLabel.text = infoDic.objectForKey("title") as NSString
        cell.dueLabel.text = dateString
        
        cell.callButton.tag = indexPath.row
        cell.textButton.tag = indexPath.row
        cell.mailButton.tag = indexPath.row
        
        cell.callButton.addTarget(self, action: "callSomeOne:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.textButton.addTarget(self, action: "textSomeOne:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.mailButton.addTarget(self, action: "mailSomeOne:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func callSomeOne(sender: UIButton) {
        let infoDic: NSDictionary = toDoItems.objectAtIndex(sender.tag) as NSDictionary
        let phoneNumber = infoDic.objectForKey("phone") as NSString
        
        UIApplication.sharedApplication().openURL(NSURL(string:"telprompt://\(phoneNumber)")!)
        
    }
    
    func textSomeOne(sender: UIButton) {
        let infoDic: NSDictionary = toDoItems.objectAtIndex(sender.tag) as NSDictionary
        let phoneNumber = infoDic.objectForKey("phone") as NSString
        
        if MFMessageComposeViewController.canSendText() {
            let messageController: MFMessageComposeViewController = MFMessageComposeViewController ()
            messageController.recipients = ["\(phoneNumber)"]
            messageController.messageComposeDelegate = self
            
            self.presentViewController(messageController, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        //controller.dismissViewControllerAnimated(true, completion: nil)
        
        switch result.value {
            case MessageComposeResultSent.value :
                controller.dismissViewControllerAnimated(true, completion: nil)
            case MessageComposeResultCancelled.value:
                controller.dismissViewControllerAnimated(true, completion: nil)
            default:
                controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func mailSomeOne(sender: UIButton) {
        let infoDic: NSDictionary = toDoItems.objectAtIndex(sender.tag) as NSDictionary
        let email = infoDic.objectForKey("email") as NSString
        
        if MFMailComposeViewController.canSendMail() {
            let mailController: MFMailComposeViewController = MFMailComposeViewController ()
            mailController.setCcRecipients (["\(email)"])
            mailController.mailComposeDelegate = self
            
            self.presentViewController(mailController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
           // controller.dismissViewControllerAnimated(true, completion: nil)
        
        switch result.value {
            case MFMailComposeResultCancelled.value :
                controller.dismissViewControllerAnimated(true, completion: nil)
            case MFMailComposeResultSent.value :
                controller.dismissViewControllerAnimated(true, completion: nil)
            default:
                controller.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            if (toDoItems.count > 0) {
                let infoDic: NSDictionary = toDoItems.objectAtIndex(indexPath.row) as NSDictionary
                
                let moc: NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
                let identifier: NSString = infoDic.objectForKey("identifier") as NSString
                let predicate: NSPredicate = NSPredicate(format: "identifier == '\(identifier)'")!
                
                let results: NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(TodoItem), withPredicate: predicate, managedObjectContext: moc)
                
                let toDoItemDelete: TodoItem = results.lastObject as TodoItem
                
                toDoItemDelete.managedObjectContext?.deleteObject(toDoItemDelete)
                
                SwiftCoreDataHelper.saveManagedObjectContext(moc)
                loadData()
                self.tableView.reloadData()
                
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
