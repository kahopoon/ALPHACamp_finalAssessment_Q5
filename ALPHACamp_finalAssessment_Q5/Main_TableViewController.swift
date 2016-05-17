//
//  Main_TableViewController.swift
//  ALPHACamp_finalAssessment_Q5
//
//  Created by Ka Ho on 17/5/2016.
//  Copyright © 2016 Ka Ho. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD
import SDWebImage

class Main_TableViewController: UITableViewController, passInsertionBack {

    var allAnimalInfoWohooooo:[animalInfo] = []
    var userInsertionIDSequence:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    func getData() {
        // show label
        HUD.show(.LabeledProgress(title: "動物集合中", subtitle: "請稍候。。。"))
        // remove cache
        allAnimalInfoWohooooo.removeAll()
        // get sequence number
        userInsertionIDSequence = NSUserDefaults.standardUserDefaults().integerForKey("insertionID")
        // load local data
        if NSUserDefaults.standardUserDefaults().objectForKey("nameOfID0") != nil {
            for loop in 0..<userInsertionIDSequence {
                let eachAnimal = animalInfo()
                eachAnimal.id = loop
                eachAnimal.name = String(NSUserDefaults.standardUserDefaults().objectForKey("nameOfID\(loop)")!)
                eachAnimal.pic = NSHomeDirectory().stringByAppendingString("/Documents/\(loop).jpg")
                allAnimalInfoWohooooo.append(eachAnimal)
            }
        }
        // load internet data
        getAnimalInfoAPI_Call { (result) in
            var currentID = self.userInsertionIDSequence
            let animals = result["result"]["results"].arrayValue
            for animal in animals {
                let eachAnimal = animalInfo()
                eachAnimal.id = currentID
                eachAnimal.name = animal["A_Name_Ch"].stringValue
                eachAnimal.pic = animal["A_Pic01_URL"].stringValue
                self.allAnimalInfoWohooooo.append(eachAnimal)
                currentID += 1
            }
            // reload, remove loading label
            self.tableView.reloadData()
            HUD.hide()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAnimalInfoWohooooo.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Main_TableViewCell", forIndexPath: indexPath) as! Main_TableViewCell
        indexPath.row >= userInsertionIDSequence ? (cell.animalPic.sd_setImageWithURL(NSURL(string: allAnimalInfoWohooooo[indexPath.row].pic!))) : (cell.animalPic.image = UIImage(data: NSData(contentsOfFile: allAnimalInfoWohooooo[indexPath.row].pic!)!, scale: 1.0))
        cell.animalName.text = allAnimalInfoWohooooo[indexPath.row].name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "insertNewAnimal" {
            let vc = segue.destinationViewController as! insertRecord_ViewController
            vc.insertionDelegate = self
        }
    }
    
    func sendDataToPreviousVC(name: String, pic: UIImage) {
        // save image to file
        let image:NSData = UIImageJPEGRepresentation(pic, 1)!
        let imagePath = NSHomeDirectory().stringByAppendingString("/Documents/\(userInsertionIDSequence).jpg")
        image.writeToFile(imagePath, atomically: true)
        // save image name to nsdefaults
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: "nameOfID\(userInsertionIDSequence)")
        // update sequence
        userInsertionIDSequence += 1
        NSUserDefaults.standardUserDefaults().setInteger(userInsertionIDSequence, forKey: "insertionID")
        NSUserDefaults.standardUserDefaults().synchronize()
        //
        getData()
    }
}
