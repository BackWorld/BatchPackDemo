//
//  ViewController.swift
//  BatchPackDemo
//
//  Created by zhuxuhong on 2017/5/11.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let dict = Bundle.main.infoDictionary!
        
        infoLabel.text = "display name: \(dict["CFBundleDisplayName"]!)\n\nbundle id: \(dict["CFBundleIdentifier"]!)\n\nbundle version: \(dict["CFBundleVersion"]!)"
        
    }

}

