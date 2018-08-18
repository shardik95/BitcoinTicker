//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Hardik Shah on 8/10/18.
//  Copyright © 2018 Hardik Shah. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
   
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    let URL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var finalURL : String = ""
    var finalSymbol: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = "\(URL)\(currencyArray[row])"
        finalSymbol = currencySymbol[row];
        getBitcoinData(url: finalURL)
    }
    
    func getBitcoinData(url:String){
        
        Alamofire.request(url, method: .get).responseJSON{
            response in
            if response.result.isSuccess{
                let json : JSON = JSON(response.result.value!)
                self.updateUI(json)
            }
            else{
                print(response.result.error!)
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateUI(_ json :JSON){
        let price = json["averages"]["day"].stringValue
        bitcoinPriceLabel.text = "\(finalSymbol) \(price)"
    }
    

}

