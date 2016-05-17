//
//  insertRecord_ViewController.swift
//  ALPHACamp_finalAssessment_Q5
//
//  Created by Ka Ho on 17/5/2016.
//  Copyright © 2016 Ka Ho. All rights reserved.
//

import UIKit

protocol passInsertionBack: class
{
    func sendDataToPreviousVC(name:String, pic:UIImage)
}

class insertRecord_ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var insertPicFrame: UIImageView!
    @IBOutlet weak var insertNameTextfield: UITextField!
    @IBOutlet weak var insertPicButton, confirmToAddButton: UIButton!
    
    weak var insertionDelegate:passInsertionBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertPicFrame.layer.borderColor = UIColor.orangeColor().CGColor
        insertPicFrame.layer.borderWidth = 1
        insertNameTextfield.layer.borderColor = UIColor.orangeColor().CGColor
        insertNameTextfield.layer.borderWidth = 1
        confirmToAddButton.layer.borderColor = UIColor.orangeColor().CGColor
        confirmToAddButton.layer.borderWidth = 1
        
        // default to open camera when view load
        takePhotoAction(self)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.insertPicFrame.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func takePhotoAction(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func confirmToAddAction(sender: AnyObject) {
        insertPicFrame.image != nil && insertNameTextfield.hasText() ? dataPassBack() : invalidInputWarning()
    }
    
    func dataPassBack() {
        insertionDelegate?.sendDataToPreviousVC(insertNameTextfield.text!, pic: insertPicFrame.image!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func invalidInputWarning() {
        let alertController = UIAlertController(title: "資料還沒填妥喔", message: "請確定已插入照片與動物名稱！", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
