//
//  MessageBody.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

enum MessageBody {
    case text(String)
    case image(ImageRef)
    case audio(AudioRef)
    case systemNotice(String)
}
