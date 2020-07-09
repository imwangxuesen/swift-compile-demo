//
//  Enum-Interpreter.swift
//  swift-interpreter
//
//  Created by WangXuesen on 2020/7/8.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation

public enum OCToken: Equatable {
    case constant(OCConstant)
    case operation(OCOperation)
    case paren(OCDirection)
    case eof
    case whiteSpaceAndNewLine
    
    public static func == (lhs: OCToken, rhs: OCToken) -> Bool{
        switch (lhs, rhs) {
        case let (OCToken.constant(left), OCToken.constant(right)):
            return left == right
        case let (OCToken.operation(left), OCToken.operation(right)):
            return left == right
        case (OCToken.eof, OCToken.eof):
            return true
        case (OCToken.whiteSpaceAndNewLine, OCToken.whiteSpaceAndNewLine):
            return true
        case let (OCToken.paren(left), OCToken.paren(right)):
            return left == right
        default:
            return false
        }
    }
}

public enum OCDirection: Equatable {
    case left
    case right
    
    public static func == (lhs: OCDirection, rhs: OCDirection) -> Bool {
        switch (lhs, rhs) {
        case (OCDirection.left, OCDirection.left):
            return true
        case (OCDirection.right, OCDirection.right):
            return true
        default:
            return false
        }
    }
}

public enum OCConstant: Equatable{
    case integer(Int)
    case float(Float)
    case boolean(Bool)
    case string(String)
    
    public static func == (lhs: OCConstant, rhs: OCConstant) -> Bool {
        switch (lhs, rhs) {
        case let (OCConstant.integer(left), OCConstant.integer(right)):
            return left == right
        case let (OCConstant.float(left), OCConstant.float(right)):
            return left == right
        case let (OCConstant.boolean(left), OCConstant.boolean(right)):
            return left == right
        case let (OCConstant.string(left), OCConstant.string(right)):
            return left == right
        default:
            return false
        }
    }
}

public enum OCOperation: Equatable {
    case plus
    case minus
    case mult
    case intDiv
    
    public static func == (lhs: OCOperation, rhs: OCOperation) -> Bool{
        switch (lhs, rhs) {
        case let (OCOperation.plus, OCOperation.plus):
            return true
        case let (OCOperation.minus, OCOperation.minus):
            return true
        case let (OCOperation.mult, OCOperation.mult):            return true
        case let (OCOperation.intDiv,
                  OCOperation.intDiv):
            return true
        default:
            return false
        }
    }
}
