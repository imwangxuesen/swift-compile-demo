//
//  JLexer.swift
//  swift-interpreter
//
//  Created by WangXuesen on 2020/7/9.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation

public class JLexer {
    private let text: String
    private var currentIndex: Int
    private var currentCharacter: Character?
    
    
    public init(_ input: String) {
        if input.count == 0 {
            fatalError("Error! input can not be empty")
        }
        self.text = input
        currentIndex = 0
        currentCharacter = text[text.startIndex]
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
    
    // 流程函数
    func nextTk() -> OCToken {
        if currentIndex > self.text.count - 1 {
            return .eof
        }
        
        // 跳过换行或者空白
        if CharacterSet.whitespacesAndNewlines.contains((currentCharacter?.unicodeScalars.first!)!) {
            skipWhiteSpaceAndNewLines()
            return .whiteSpaceAndNewLine
        }
        
        // 返回数字
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
        
        if currentCharacter == "(" {
            advance()
            return .paren(.left)
        }
        
        if currentCharacter == ")" {
            advance()
            return .paren(.right)
        }
        
        advance()
        return .eof
    }
    
    // 在当前current index不变的情况下，获取前一个字符
    private func peek() -> Character? {
        let peekIndex = currentIndex + 1
        guard peekIndex < text.count else {
            return nil
        }
        return text[text.index(text.startIndex, offsetBy: peekIndex)]
    }
    
    // 数字处理，支持浮点数
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
    
    private func skipWhiteSpaceAndNewLines() {
        while CharacterSet.whitespacesAndNewlines.contains((currentCharacter?.unicodeScalars.first!)!) {
            advance()
        }
    }
}
