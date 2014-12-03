//
//  IntroViewController.swift
//  MuseumApp
//
//  Created by Philipp Meier on 01.12.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var introText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

