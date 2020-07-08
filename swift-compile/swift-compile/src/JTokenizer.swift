//
//  JTokenizer.swift
//  swift-compile
//
//  Created by WangXuesen on 2020/7/7.
//  Copyright © 2020 swift. All rights reserved.
//  词法分析器 将代码切成一个又一个的token

import Foundation

public class JTokenizer {
    private var _input: String
    private var _index: String.Index
    
    public init(_ input: String) {
        _input = input
        _index = _input.startIndex
    }
    
    public func tokenizer() -> [JToken] {
        var tokens = [JToken]()
        while let aChar = currentChar {
            let s = aChar.description
            let symbols = ["(",")",","," "]
            if symbols.contains(s) {
                if s == " "  {
                    // 空格
                    advanceIndex()
                    continue
                }
                // 如果是左右括号
                tokens.append(JToken(type: "paren", value: s))
                advanceIndex()
                continue
            } else {
                // 如果不是边界符号
                var word = ""
                // 从当前字符向后遍历
                while let sChar = currentChar {
                    let str = sChar.description
                    // 如果是边界符号就退出
                    if symbols.contains(str) {
                        break;
                    }
                    // 如果不是边界符号就追加到word中并向后继续遍历
                    word.append(str)
                    advanceIndex()
                    continue
                }
                if word.count > 0 {
                    var tkType = "char"
                    if word.isFloat() {
                        tkType = "float"
                    }
                    if word.isInt() {
                        tkType = "int"
                    }
                    tokens.append(JToken(type: tkType, value: word))
                }
                continue
            }
            
        }
        print("Tokens: \(tokens) \n")
        return tokens
    }
    
    // parser tool
    var currentChar: Character? {
        return _index < _input.endIndex ? _input[_index] : nil
    }
    
    func advanceIndex() {
        _input.formIndex(after: &_index)
    }
}
