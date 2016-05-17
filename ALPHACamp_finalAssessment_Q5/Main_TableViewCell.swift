//
//  Main_TableViewCell.swift
//  ALPHACamp_finalAssessment_Q5
//
//  Created by Ka Ho on 17/5/2016.
//  Copyright © 2016 Ka Ho. All rights reserved.
//

import UIKit

class Main_TableViewCell: UITableViewCell {

    @IBOutlet weak var animalPic: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
