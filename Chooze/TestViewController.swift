//
//  TestViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 10/1/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.LandscapeRight.toRaw())
    }
    

    

}
