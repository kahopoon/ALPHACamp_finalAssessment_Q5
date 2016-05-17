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

class Main_TableViewController: UITableViewController {

    var allAnimalInfoWohooooo:[animalInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
    }

    func getData() {
        HUD.show(.LabeledProgress(title: "動物集合中", subtitle: "請稍候。。。"))
        getAnimalInfoAPI_Call { (result) in
            let animals = result["result"]["results"].arrayValue
            for animal in animals {
                let eachAnimal = animalInfo()
                eachAnimal.id = animal["_id"].stringValue
                eachAnimal.name = animal["A_Name_Ch"].stringValue
                eachAnimal.pic = animal["A_Pic01_URL"].stringValue
                self.allAnimalInfoWohooooo.append(eachAnimal)
                self.tableView.reloadData()
                HUD.hide()
            }
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
        cell.animalPic.sd_setImageWithURL(NSURL(string: allAnimalInfoWohooooo[indexPath.row].pic!))
        cell.animalName.text = allAnimalInfoWohooooo[indexPath.row].name
        return cell
    }
}
