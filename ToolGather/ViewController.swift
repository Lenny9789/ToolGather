//
//  ViewController.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/8.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit
import DeviceKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
    }

    private func setViews() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("\(self) \(#function) -->  Size:", MainScreen)
        
    }

}

