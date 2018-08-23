//
//  ViewController.swift
//  Stocks
//
//  Created by Noah Eaton on 8/21/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    var stockArray : Results<Stocks>?
    
    let baseURL = "https://api.iextrading.com/1.0/stock/"
    var finalURL = "https://api.iextrading.com/1.0/stock/"
    
    
    @IBOutlet weak var stockPriceLabel: UILabel!
    @IBOutlet weak var stockOpenLabel: UILabel!
    @IBOutlet weak var stockCloseLabel: UILabel!
    @IBOutlet weak var stockHighLabel: UILabel!
    @IBOutlet weak var stockLowLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItems()
        
    }

    
    
    
    func getStockData(url : String) {
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("Successfully got the data")
                print(response)
                
                let stockJSON : JSON = JSON(response.result.value!)
                
                self.updateStockData(json: stockJSON)
            } else {
                
                self.navigationItem.title = "stock not found"
                
                self.stockPriceLabel.text = "Price:"
                
                self.stockOpenLabel.text = "Open:"
                
                self.stockCloseLabel.text = "Previous Close:"
                
                self.stockHighLabel.text = "High:"
                
                self.stockLowLabel.text = "Low:"
                
            }
            
            
        }
        
        
    }
    
    func updateStockData(json : JSON) {
        
        let jsonQuote = json["quote"]
        
        if let stockResult = jsonQuote["delayedPrice"].double {
            stockPriceLabel.text = "Price: $\(stockResult)"
            
            //Create an auto-adjusting navigation title based on the amount of text
            self.title = jsonQuote["companyName"].string
            let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
            tlabel.text = self.title
            tlabel.textColor = UIColor.black
            tlabel.font = UIFont(name: "Helvetica", size: 30.0)
            tlabel.backgroundColor = UIColor.clear
            tlabel.adjustsFontSizeToFitWidth = true
            tlabel.textAlignment = .center;
            self.navigationItem.titleView = tlabel
            
            stockOpenLabel.text = "Open: $\(jsonQuote["open"])"
            
            stockCloseLabel.text = "Previous Close: $\(jsonQuote["close"])"
            
            stockHighLabel.text = "High: $\(jsonQuote["high"])"
            
            stockLowLabel.text = "Low: $\(jsonQuote["low"])"
            
            
            
        } else {
            stockPriceLabel.text = "Price unavailable"
        }
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
        //create an alert to create a new reminder
        let alert = UIAlertController(title: "See Stock", message: "", preferredStyle: .alert)
        
        //give it an action
        let action = UIAlertAction(title: "View Stock", style: .default) { (action) in
            
            let newStock = Stocks()
            newStock.stockName = textField.text!
            self.saveItems(stock: newStock)
            
            self.loadItems()
            
            let ticker = textField.text!
            self.finalURL = self.baseURL + ticker + "/book"
            self.getStockData(url: self.finalURL)
            
    
            
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        //give the alert the textField
        alert.addTextField { (textfield) in
            textfield.placeholder = "Stock Ticker(ex. AAPL)"
            textField = textfield
            
        }
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true,  completion: nil)
        
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        
        getStockData(url: finalURL)
        
    }

    
    func saveItems(stock : Stocks) {
        do {
            try realm.write {
                realm.add(stock)
            }
        } catch {
            print("Error saving to realm database")
        }

    }
    
    func loadItems() {
        
        stockArray = realm.objects(Stocks.self)
        let anotherArray = stockArray!.last

        if let lastStockName = anotherArray?.stockName {
            self.finalURL = self.baseURL + lastStockName + "/book"
            self.getStockData(url: self.finalURL)
        }

        
        //print("This is a stock array\(stockArray)")
        
    }
    

}

