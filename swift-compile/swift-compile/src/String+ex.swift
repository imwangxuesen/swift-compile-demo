//
//  String+ex.swift
//  swift-compile
//
//  Created by WangXuesen on 2020/7/7.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation

extension String {
    func isInt() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var val: Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    func isFloat() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var val: Float = 0
        return scan.scanFloat(&val) && scan.isAtEnd
    }
}
