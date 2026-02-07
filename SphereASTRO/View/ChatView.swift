//
//  ChatView.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation
import SwiftUI

struct ChatView: View {
    @StateObject private var vm = ChatViewModel()
    @State private var input = ""

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(vm.messages) {
                        MessageRow(message: $0)
                    }
                }
            }

            HStack {
                TextField("Message", text: $input)
                Button("Send") {
                    vm.send(text: input)
                    input = ""
                }
            }
            .padding()
        }
    }
}
