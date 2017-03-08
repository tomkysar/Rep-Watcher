//
//  ViewController.swift
//  RepWatcher
//
//  Created by Tom Kysar on 10/13/16.
//  Copyright © 2016 Tom Kysar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var PriceUSD: UILabel!
    @IBOutlet var PriceBTC: UILabel!
    @IBOutlet var Change1H: UILabel!
    @IBOutlet var Change1D: UILabel!
    @IBOutlet var Change7D: UILabel!
    @IBOutlet var VolumeUSD: UILabel!
    @IBOutlet var CapUSD: UILabel!
    @IBOutlet var LastUpdated: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMarketData()
    }
    
    func viewDidAppear() {
        getMarketData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMarketData() {
        
        let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/augur/")
        let request = URLRequest(url: url!)
        let data = try? NSURLConnection.sendSynchronousRequest(request, returning: nil)
        
        if data != nil {
            
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = NumberFormatter.Style.currency
            currencyFormatter.locale = Locale.current
            
            let currencyFormatterZero = NumberFormatter()
            currencyFormatterZero.usesGroupingSeparator = true
            currencyFormatterZero.numberStyle = NumberFormatter.Style.currency
            currencyFormatterZero.maximumFractionDigits = 0
            currencyFormatterZero.locale = Locale.current
            
            var json = JSON(data: data!)
            let repPriceUSD = json[0]["price_usd"].doubleValue
            let repPriceUSDFormatted = currencyFormatter.string(from: NSNumber(value: repPriceUSD))
            self.PriceUSD.text = repPriceUSDFormatted!
            
            let repPriceBTC = json[0]["price_btc"]
            self.PriceBTC.text = repPriceBTC.description + " BTC"
            
            let change1h = json[0]["percent_change_1h"]
            self.Change1H.text = change1h.description + "%"
            
            let change1d = json[0]["percent_change_24h"]
            self.Change1D.text = change1d.description + "%"
            
            let change7d = json[0]["percent_change_7d"]
            self.Change7D.text = change7d.description + "%"

            let volumeUSD = json[0]["24h_volume_usd"].doubleValue
            let volumeUSDFormatted = currencyFormatterZero.string(from: NSNumber(value: volumeUSD))
            self.VolumeUSD.text = volumeUSDFormatted!
                
            let capUSD = json[0]["market_cap_usd"].doubleValue
            let capUSDFormatted = currencyFormatterZero.string(from: NSNumber(value:capUSD))
            self.CapUSD.text = capUSDFormatted!
            
            let updatedTime = json[0]["last_updated"].doubleValue
            let date = Date(timeIntervalSince1970: updatedTime)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "hh:mm a"
            let dateString = dayTimePeriodFormatter.string(from: date)
            self.LastUpdated.text = "Last Updated: " + dateString

        }
    }
}

