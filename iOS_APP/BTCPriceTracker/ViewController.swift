//
//  ViewController.swift
//  BTCPriceTracker
//
//  Created by William Leonard Sumendap on 7/7/19.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
    }
    
    @IBOutlet weak var btcPrice: UILabel!
    
    var price = 0.0;
    var prevPrice = 0.0;
    
    @IBOutlet weak var highField: UITextField!
    @IBOutlet weak var lowField: UITextField!
    
    var high = 1000000.0;
    var low = 0.0;
    
    // Manually set the bounds (function needs to be renamed in the future, button connection needs to be reconfigured to avoid SIGABRT)
    @IBAction func getPrice(_ sender: Any) {

        guard let h = Double(highField.text!) else {
            print("Invalid high value")
            return
        }
        guard let l = Double(lowField.text!) else {
            print("Invalid low value")
            return
        }
        self.high = h
        self.low = l
    }
    
 
    
    func setLabel(price : Double) {
        btcPrice.text = String(price)
    }
    
    func update(price : Double) {
        self.prevPrice = self.price
        self.price = price
        btcPrice.text = String(price)
    }
    
    func notify(low : Double, high : Double) {
        if (self.price < low && self.prevPrice >= low) {
            let content = UNMutableNotificationContent()
            content.title = "BTC Price Alert"
            content.body = "BTC Dropped Below " + String(low) + " USD"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "Timer Done", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        if ((self.price) > high && self.prevPrice <= high) {
            let content = UNMutableNotificationContent()
            content.title = "BTC Price Alert"
            content.body = "BTC Surpasses " + String(high) + " USD"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "Timer Done", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
    }
    
}

