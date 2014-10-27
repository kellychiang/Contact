//
//  ContactTableViewController.swift
//  Contact
//
//  Created by kelly on 2014/10/17.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import UIKit
import CoreData


protocol ContactSelectionDelegate{
    func userDidSelectContact(contactIdentifier:NSString)
}

class ContactsTableViewController: UITableViewController {
    
    var yourContacts:NSMutableArray = NSMutableArray ()
    var delegate:ContactSelectionDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        self.tableView.rowHeight = 100
    }
    
    func loadData () {
        yourContacts.removeAllObjects()
        
        let moc: NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        
        let results: NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(Contact), withPredicate: nil, managedObjectContext: moc)
        
        for contact in results {
            let singleContact: Contact = contact as Contact
            
            let contactDic: NSDictionary = ["identifier"   : singleContact.identifier,
                                            "firstName"    : singleContact.firstName ,
                                            "lastName"     : singleContact.lastName ,
                                            "email"        :singleContact.email,
                                            "phone"        :singleContact.phone,
                                            "contactImage" :singleContact.contactImageView]
            yourContacts.addObject(contactDic)
            
        }
        self.tableView.reloadData()
        
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
        
        return yourContacts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ContactCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as ContactCellTableViewCell

        // Configure the cell...
        
        let contactDict: NSDictionary = yourContacts.objectAtIndex(indexPath.row) as NSDictionary
        
        let firstName         = contactDict.objectForKey("firstName") as String
        let lastName          = contactDict.objectForKey("lastName") as String
        let email             = contactDict.objectForKey("email") as String
        let phone             = contactDict.objectForKey("phone") as String
        let imageData: NSData = contactDict.objectForKey("contactImage") as NSData
        
        let contactImage: UIImage = UIImage (data: imageData)!
        
        cell.nameLabel.text = firstName + " " + lastName
        cell.phoneLabel.text = phone
        cell.emailLabel.text = email
        
        var contactImageFrame: CGRect = cell.contactImageview.frame
        contactImageFrame.size = CGSizeMake(75, 75)
        cell.contactImageview.frame = contactImageFrame
        cell.contactImageview.image = contactImage

        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (delegate != nil) {
            let contactDic:NSDictionary = yourContacts.objectAtIndex(indexPath.row) as NSDictionary
            
            delegate?.userDidSelectContact(contactDic.objectForKey("identifier") as NSString)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
