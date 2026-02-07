//
//  FAMCore.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

protocol FAMCore {
    associatedtype Psi
    associatedtype Phi
    associatedtype Lambda
    associatedtype Q
    
    var kind: FAMKind { get }

    var psi: Psi { get }
    var phi: Phi { get }
    var lambda: Lambda? { get }   // 未生成状態を許す
    var q: Q { get }
}
