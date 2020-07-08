//
//  JTransformer.swift
//  swift-compile
//
//  Created by WangXuesen on 2020/7/7.
//  Copyright © 2020 swift. All rights reserved.
//  代码转换器 将生成的节点使用JTraverser遍历器执行对应的闭包,构建C语言函数调用的节点数

import Foundation

public class JTransformer {
    
    public var currentParent: JNode = JNode()
    public var ast: [JNode] = [JNode]()
    public var tokens: [JNode] = [JNode]()
    public init(_ input: String) {
        self.tokens =  JParser(input).parser()
        
        // 父节点有两种情况:一种是ExpressionStatement类型节点,另一种是CallExpression类型节点,这两种类型节点都要将当前的NumberLiteral类型节点添加到父节点的arguments里
        let numberLiteralClosure: VisitorClosure = { (node, parent) in
            if self.currentParent.type == .ExpressionStatement {
                self.currentParent.expressions[0].arguments.append(node)
            }
            
            if self.currentParent.type == .CallExpression {
                self.currentParent.arguments.append(node)
            }
        }
        
        // 两种情况,一种负节点也是CallExpression类型节点,另一种负节点不是CallExpression类型节点,则需要判断是否是root类型的根节点
        // 如果不是callexpression类型节点,就需要生成一个新的ExpressionStatement类型节点,在父节点是Root类型的情况下,将其添加到新的AST的根下,然后把currentParent设为新生成的ExpressionStatement类型节点
        //  如果是CallExpression类型节点,那么父节点在以上示例里就是ExpressionStatement类型节点且这个CallExpression类型节点在以上示例里就一定为参数,我们只需要将其添加到ExpressionStatement的expressions的arguments里即可
        let callExpressionClosure: VisitorClosure = { (node, parent) in
            let exp = JNode()
            exp.type = .CallExpression
            var callee = JNodeCallee()
            callee.type = .Identifier
            callee.name = node.name
            exp.callee = callee
            
            if parent.type != .CallExpression {
                let exps = JNode()
                exps.type = .ExpressionStatement
                exps.expressions.append(exp)
                if parent.type == .Root {
                    self.ast.append(exps)
                }
                self.currentParent = exps
            } else {
                self.currentParent.expressions[0].arguments.append(exp)
                self.currentParent = exp
            }
        }
        let traverser = JTraverser.init(self.tokens)
        traverser.traverser(visitor: [JNodeType.NumberLiteral.rawValue: numberLiteralClosure, JNodeType.CallExpression.rawValue: callExpressionClosure])
        
    }
}
