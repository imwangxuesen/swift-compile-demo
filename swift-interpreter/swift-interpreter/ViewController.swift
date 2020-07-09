//
//  ViewController.swift
//  swift-interpreter
//
//  Created by WangXuesen on 2020/7/8.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let interperter = JInterpreter("1.9*8.0")
        let result = interperter.expr()
        print(result)
        // Do any additional setup after loading the view.
    }


}

