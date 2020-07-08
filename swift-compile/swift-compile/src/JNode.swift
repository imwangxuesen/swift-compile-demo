//
//  JNode.swift
//  swift-compile
//
//  Created by WangXuesen on 2020/7/7.
//  Copyright © 2020 swift. All rights reserved.
//  语法分析节点,包含表明节点类型的枚举节点,记录节点值的值节点和值类型

import Foundation

// 值类型
public enum JNumberType: String, Codable {
    case int,float
}

// 节点类型
public enum JNodeType: String, Codable {
    // 无意义
    case None
    // 代码转换/生成过程的根节点
    case Root
    // 参数类型节点
    case NumberLiteral
    // 方法类型节点
    case CallExpression
    // 代码生成过程中的root之下的描述节点
    case ExpressionStatement
    // 表示性节点
    case Identifier
}

public protocol JNodeBase {
    var type: JNodeType { get }
    var name: String { get }
    var params: [JNode] { get }
}

public protocol JNodeNumberLiteral {
    var numberType: JNumberType { get }
    var intValue: Int { get }
    var floatValue: Float { get }
}

public class JNode: JNodeBase, JNodeNumberLiteral, Codable {
    public var type = JNodeType.None
    public var name = ""
    // 解析步骤的CallExpression类型节点的参数
    public var params = [JNode]()
    public var numberType = JNumberType.int
    // 值类型节点的int数值
    public var intValue: Int = 0
    // 值类型节点的float数值
    public var floatValue: Float = 0.0
    // 参数,代码转换后的CallExpression类型数据的参数
    public var arguments: [JNode] = [JNode]()
    // 描述信息
    public var expressions: [JNode] = [JNode]()
    // 执行类型节点(方法信息)
    public var callee: JNodeCallee = JNodeCallee()
    
}
