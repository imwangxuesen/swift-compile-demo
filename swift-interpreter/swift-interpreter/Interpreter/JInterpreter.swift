//
//  JInterpreter.swift
//  swift-interpreter
//
//  Created by WangXuesen on 2020/7/8.
//  Copyright © 2020 swift. All rights reserved.
//  代码解释器

import Foundation

public class JInterpreter {
    private let text: String
    private var currentIndex: Int
    private var currentCharacter: Character?
    
    private var currentTk: OCToken
    
    public init(_ input: String) {
        if input.count == 0 {
            fatalError("Error! input can not be empty")
        }
        self.text = input
        currentIndex = 0
        currentCharacter = text[text.startIndex]
        currentTk = .eof
    }
    
    /// 移动到下一个位置
    func advance() {
        currentIndex += 1
        guard currentIndex < text.count else {
            currentCharacter = nil
            return
        }
        currentCharacter = text[text.index(text.startIndex,offsetBy: currentIndex)]
    }
    
    // 获取下一个token
    func nextTk() -> OCToken {
        if currentIndex > self.text.count - 1 {
            return .eof
        }
        
        if CharacterSet.whitespacesAndNewlines.contains((currentCharacter?.unicodeScalars.first!)!) {
            skipWhiteSpaceAndNewLines()
            return .whiteSpaceAndNewLine
        }
        
        if CharacterSet.decimalDigits.contains((currentCharacter?.unicodeScalars.first!)!) {
            return number()
        }
        
        if currentCharacter == "+" {
            advance()
            return .operation(.plus)
        }
        
        if currentCharacter == "-" {
            advance()
            return .operation(.minus)
        }
        
        if currentCharacter == "*" {
            advance()
            return .operation(.mult)
        }
        
        if currentCharacter == "/" {
            advance()
            return .operation(.intDiv)
        }
        
        advance()
        return .eof
    }
    
    // 进行解释
    func expr() -> Float {
        
        currentTk = nextTk()
        
        guard case let .constant(.float(left)) = currentTk else {
            return 0
        }
        eat(currentTk)
        
        let op = currentTk
        eat(currentTk)
        
        guard case let .constant(.float(right)) = currentTk else {
            return 0
        }
        eat(currentTk)
        
        switch op {
        case .operation(.plus):
            return left + right
        case .operation(.minus):
            return left - right
        case .operation(.mult):
            return left * right
        case .operation(.intDiv):
            return left / right
        default:
            return left + right
        }
        
        return left + right
    }
    
    func number() -> OCToken {
        var numStr = ""
        while let character: Character = currentCharacter, CharacterSet.decimalDigits.contains((character.unicodeScalars.first!)) {
            numStr += String(character)
            advance()

        }
        
        
        if let character: Character = currentCharacter, character == "." {
            numStr += "."
            advance()
            while let character:Character = currentCharacter, CharacterSet.decimalDigits.contains(character.unicodeScalars.first!) {
                numStr += String(character)
                advance()
                
            }
            return .constant(.float(Float(numStr)!))
        }
        
        
        return .constant(.integer(Int(numStr)!))
    }
    
    func eat(_ token: OCToken) {
        if currentTk == token {
            currentTk = nextTk()
            if currentTk == .whiteSpaceAndNewLine {
                currentTk = nextTk()
            }
        } else {
            fatalError("Error: eat wrong")

        }
        
    }
    
    private func skipWhiteSpaceAndNewLines() {
        while CharacterSet.whitespacesAndNewlines.contains((currentCharacter?.unicodeScalars.first!)!) {
            advance()
        }
    }
}
