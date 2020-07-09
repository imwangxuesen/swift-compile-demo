//
//  JInterpreter.swift
//  swift-interpreter
//
//  Created by WangXuesen on 2020/7/8.
//  Copyright © 2020 swift. All rights reserved.
//  代码解释器

import Foundation

public class JInterpreter {

    private var lexer: JLexer
    private var currentTk: OCToken
    
    public init(_ input: String) {
        lexer = JLexer(input)
        currentTk = lexer.nextTk()
    }
    
    // 进行解释
    func expr() -> Int {
        var result = term()
        while [OCToken.operation(.plus),OCToken.operation(.minus)].contains(currentTk) {
            let tk = currentTk
            eat(currentTk)
            if tk == .operation(.plus) {
                result = result + self.term()
            } else if tk == .operation(.minus) {
                result = result - self.term()
            }
        }
        return result
        
    }
    
    func term() -> Int {
        var result = factor()
        while [OCToken.operation(.mult), OCToken.operation(.intDiv)].contains(currentTk) {
            let tk = currentTk
            eat(currentTk)
            if tk == OCToken.operation(.mult) {
                result = result * factor()
            } else if tk == OCToken.operation(.intDiv) {
                result = result / factor()
            }
        }
        return result
    }
    
    func factor() -> Int {
        let tk = currentTk
        switch tk {
        case let .constant(.integer(result)):
            eat(.constant(.integer(result)))
            return result
        case .paren(.left):
            eat(.paren(.left))
            let result = expr()
            eat(.paren(.right))
            return result
        default:
            return 0
        }
    }
    
    func eat(_ token: OCToken) {
        if currentTk == token {
            currentTk = lexer.nextTk()
            if currentTk == OCToken
                .whiteSpaceAndNewLine {
                currentTk = lexer.nextTk()
            }
        } else {
            error()
        }
    }
    
    func error() -> Void {
        fatalError("Error!")
    }
    
}
