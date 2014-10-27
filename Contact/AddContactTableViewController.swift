//
//  AddContactTableViewController.swift
//  Contact
//
//  Created by kelly on 2014/10/17.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import UIKit
import CoreData

class AddContactTableViewController: UITableViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    @IBOutlet weak var firstNameTextfield: UITextField! = UITextField ()
    @IBOutlet weak var lastNameTextField: UITextField! = UITextField ()
    @IBOutlet weak var emailTextField: UITextField! = UITextField ()
    @IBOutlet weak var phoneTextField: UITextField! = UITextField ()
    @IBOutlet weak var contactImageView: UIImageView! = UIImageView ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer (target: self, action: "chooseImage:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        contactImageView.addGestureRecognizer(tapGestureRecognizer)
        contactImageView.userInteractionEnabled = true

    }
    
    func chooseImage(recognizer:UITapGestureRecognizer) {
        let imagePicker:UIImagePickerController = UIImagePickerController ()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary) {
        
        let pickedImage:UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        
        //small picture
        let smallPicture = scaleImageWith(pickedImage, newSize: CGSizeMake(100, 100))
        
        var sizeOfImageview:CGRect = contactImageView.frame
        sizeOfImageview.size = smallPicture.size
        contactImageView.frame = sizeOfImageview
        
        contactImageView.image = smallPicture
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scaleImageWith(image:UIImage , newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake( 0, 0,newSize.width, newSize.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }

    @IBAction func addButton(sender: AnyObject) {
        
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        
        var contact:Contact = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(Contact), managedObjectConect: moc) as Contact
        
        contact.identifier = "\(NSDate())"
        contact.firstName = firstNameTextfield.text
        contact.lastName = lastNameTextField.text
        contact.email = emailTextField.text
        contact.phone = phoneTextField.text
        
        let contactImageData: NSData = UIImagePNGRepresentation(contactImageView.image)
        
        contact.contactImageView = contactImageData
        
        SwiftCoreDataHelper.saveManagedObjectContext(moc)
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    */
    /*
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
