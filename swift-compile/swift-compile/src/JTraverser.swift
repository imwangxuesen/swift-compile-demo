//
//  JTraverser.swift
//  swift-compile
//
//  Created by WangXuesen on 2020/7/7.
//  Copyright © 2020 swift. All rights reserved.
//  遍历器

import Foundation

public typealias VisitorClosure = (_ node: JNode, _ parent: JNode) -> Void;

public class JTraverser {
    private var _ast: [JNode]
    
    public init(_ ast: [JNode]) {
        _ast = ast
    }
    
    public func traverser(visitor: [String: VisitorClosure]) {
        func traverseChildNode(childrens: [JNode], parent: JNode) {
            for child in childrens {
                traverseNode(node: child, parent: parent)
            }
        }
        
        func traverseNode(node: JNode, parent: JNode) {
            // 外部传入的closure
            if visitor.keys.contains(node.type.rawValue) {
                if let closure: VisitorClosure = visitor[node.type.rawValue] {
                    closure(node,parent)
                }
            }
            
            // 看是否有子节点需要继续遍历
            if node.params.count > 0 {
                traverseChildNode(childrens: node.params, parent: node)
            }
        }
        
        var rootNode = JNode()
        rootNode.type = .Root
        traverseChildNode(childrens: _ast, parent: rootNode)
        
    }
}
