//
//  APICall.swift
//  ALPHACamp_finalAssessment_Q5
//
//  Created by Ka Ho on 17/5/2016.
//  Copyright © 2016 Ka Ho. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let animalInfoAPI_URL:String = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613"

func getAnimalInfoAPI_Call (completion: (result: JSON) -> Void) {
    Alamofire.request(.GET, animalInfoAPI_URL).responseJSON { (response) in
        completion(result: JSON(response.result.value!))
    }
}