//
//  IntroViewController.swift
//  MuseumApp
//
//  Created by Philipp Meier on 01.12.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

import UIKit
import SystemConfiguration
import CoreBluetooth

class IntroViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var introText: UITextView!
    
    var peripheralManager : CBPeripheralManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        
        if (!isConnectedToNetwork()) {
            let controller = UIAlertController(title: "Internet",
                message: "Sie sind zur Zeit nicht mit dem Internet verbunden. Bitte stellen Sie sicher, dass Sie eine Verbindung haben.",
                preferredStyle: .Alert)
            
            controller.addAction(UIAlertAction(title: "OK",
                style: .Default,
                handler: nil))
            
            presentViewController(controller, animated: true, completion: nil)
        }
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let options: Dictionary<NSString, AnyObject> = [ CBPeripheralManagerOptionShowPowerAlertKey: false ]
        peripheralManager = CBPeripheralManager(delegate: self, queue: queue, options: options)
        if let manager = peripheralManager{
            manager.delegate = self
        }
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!){

        if peripheral.state != .PoweredOn{
            
            let controller = UIAlertController(title: "Bluetooth",
                message: "Bluetooth ist zur Zeit deaktiviert. Bitte aktivieren Sie Bluetooth um die App nutzen zu können.",
                preferredStyle: .Alert)
            
            controller.addAction(UIAlertAction(title: "OK",
                style: .Default,
                handler: nil))
            
            presentViewController(controller, animated: true, completion: nil)
            
        }
        
    }

    
}

