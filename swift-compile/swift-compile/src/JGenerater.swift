//
//  JGenerater.swift
//  swift-compile
//
//  Created by WangXuesen on 2020/7/7.
//  Copyright © 2020 swift. All rights reserved.
//  生成器

import Foundation

public class JGenerater {
    
    public var code: String  = ""
    
    public init(_ input: String) {
        print("Input Code: \(input)")
        let ast = JTransformer(input).ast
        print("After transform AST: \n ")
        let encoder = JSONEncoder()
        // 默认 outputFormatting 属性值为 .compact，输出效果如上。如果将其改为 .prettyPrinted 后就能获得更好的阅读体检
        encoder.outputFormatting = .prettyPrinted
        // 将 Beer 实例转化为 JSON
        let jsonData2 = try! encoder.encode(ast)
        
        print(String(bytes: jsonData2, encoding: String.Encoding.utf8) ?? "")

        for aNode in ast {
            code.append(recGeneratorCode(aNode))
        }
        print("The code generated:")
        print(code)
    }
    
    // 递归生成代码
    public func recGeneratorCode(_ node: JNode) -> String {
        var code = ""
        if node.type == .ExpressionStatement {
            for aExp in node.expressions {
                code.append(recGeneratorCode(aExp))
            }
        }
        
        if node.type == .CallExpression {
            code.append(node.callee.name)
            code.append("(")
            if node.arguments.count > 0 {
                for (index,arg) in node.arguments.enumerated() {
                    code.append(recGeneratorCode(arg))
                    if index != node.arguments.count - 1 {
                        code.append(",")
                    }
                }
            }
            code.append(")")
        }
        
        if node.type == .Identifier {
            code.append(node.name)
        }
        
        if node.type == .NumberLiteral {
            switch node.numberType {
            case .float:
                code.append(String(node.floatValue))
            case .int:
                code.append(String(node.intValue))
            }
        }
        return code
    }
}
