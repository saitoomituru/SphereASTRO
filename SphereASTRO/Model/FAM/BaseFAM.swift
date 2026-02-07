//
//  BaseFAM.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

struct BaseFAM<Psi, Phi, Q, Lambda>: FAMCore {
    let kind: FAMKind

    let psi: Psi
    let phi: Phi
    let lambda: Lambda?
    
    let q: Q

}
