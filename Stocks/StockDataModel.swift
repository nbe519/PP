//
//  StockDataModel.swift
//  Stocks
//
//  Created by Noah Eaton on 8/22/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import Foundation
import RealmSwift


//inside each category has items that point to a list of item objects
//Category is a realm object
class Stocks : Object {
    //has name property and is dynamic so we can monitor for changes in the property during run-time
    @objc dynamic var stockName : String = ""

    
}
