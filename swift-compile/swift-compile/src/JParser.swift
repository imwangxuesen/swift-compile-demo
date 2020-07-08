//
//  JParser.swift
//  swift-compile
//
//  Created by WangXuesen on 2020/7/7.
//  Copyright © 2020 swift. All rights reserved.
//  语法解析类

import Foundation

public class JParser {
    private var _tokens: [JToken]
    private var _current: Int
    
    public init(_ input: String) {
        _tokens = JTokenizer(input).tokenizer()
        _current = 0
    }
    
    /// 解析
    public func parser() -> [JNode] {
        _current = 0
        var nodeTree = [JNode]()
        while _current < _tokens.count {
            nodeTree.append(walk())
        }
        _current = 0
        JParser.astPrintable(nodeTree)
        return nodeTree
    }
    
    /// 递归下降解析语法
    private func walk() -> JNode {
        var tk = _tokens[_current]
        var jNode = JNode()
        // 检查是不是数字类型节点,如果是数字
        if tk.type == "int" || tk.type == "float" {
            _current += 1
            jNode.type = .NumberLiteral
            if tk.type == "int", let intV = Int(tk.value) {
                jNode.intValue = intV
                jNode.numberType = .int
            }
            
            if tk.type == "float", let floatV = Float(tk.value) {
                jNode.floatValue = floatV
                jNode.numberType = .float
            }
            return jNode
        }
        
        // 检查是否为CallExpression类型
        if tk.type == "paren" && tk.value == "(" {
            // 跳过符号
            _current += 1
            tk = _tokens[_current]
            
            jNode.type = .CallExpression
            jNode.name = tk.value
            _current += 1
            // 遍历“)”之前的token,并添加到params中
            while tk.type != "paren" || (tk.type == "paren" && tk.value != ")") {
                // 递归下降
                jNode.params.append(walk())
                tk = _tokens[_current]
            }
            // 跳到下一个
            _current += 1
            return jNode
        }
        _current += 1
        return jNode
    }
    
    // AST语法树打印
    public static func astPrintable(_ tree: [JNode]) {
        for aNode in tree {
            recDesNode(aNode, level: 0)
        }
    }
    
    /// 递归打印node节点
    /// - Parameters:
    ///   - node: 节点数据
    ///   - level: 节点在AST中的level
    private static func recDesNode(_ node: JNode, level: Int) {
        let nodeTypeStr = node.type
        var preSpace = ""
        for _ in 0...level {
            if level > 0 {
                preSpace +=  "  "
            }
        }
        
        var dataStr = ""
        switch node.type {
        case .NumberLiteral:
            var numberStr = ""
            if node.numberType == .float {
                numberStr = "\(node.floatValue)"
            }
            if node.numberType == .int {
                numberStr = "\(node.intValue)"
            }
            dataStr = "number type is \(node.type) number is \(numberStr)."
            
        case .CallExpression:
            dataStr = "expression is \(node.type)(\(node.name))"
        case .None:
            dataStr = ""
        case .Root:
            dataStr = ""
        case .ExpressionStatement:
            dataStr = ""
        case .Identifier:
            dataStr = ""
        }
        print("\(preSpace) \(nodeTypeStr) \(dataStr)")
        
        if node.params.count > 0 {
            for aNode in node.params {
                recDesNode(aNode, level: level + 1)
            }
        }
        
        if node.arguments.count > 0 {
            for aNode in node.params {
                recDesNode(aNode, level: level + 1)
            }
        }
        
        if node.expressions.count > 0 {
            for aNode in node.expressions {
                recDesNode(aNode, level: level + 1)
            }
        }
    }
}
