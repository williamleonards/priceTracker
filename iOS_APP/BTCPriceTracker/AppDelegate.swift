//
//  AppDelegate.swift
//  BTCPriceTracker
//
//  Created by William Leonard Sumendap on 7/7/19.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
        if let vc = window?.rootViewController as? ViewController {
            
            let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")
            print("Loading URL")
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                print("done")
                guard let data = data, error == nil else {
                    completionHandler(.failed)
                    return
                }
                
                do {
                    print("fetching....")
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    
                    let x = ((json!["bpi"] as? [String:Any])! ["USD"] as? [String:Any])!["rate_float"] as? Double ?? 0
                    print(x)
                    
                    DispatchQueue.main.async {
                        vc.update(price: x)
                        print("prev: " + String(vc.prevPrice))
                        print("now: " + String(vc.price))
                        print("high: " + String(vc.high))
                        print("low: " + String(vc.low) + "\n")
                        vc.notify(low : vc.low, high : vc.high)
                    }
                    completionHandler(.newData)
                } catch {
                    completionHandler(.failed)
                    print("Failed to parse")
                }
            }).resume()
            
        }
    }
    
    
}

