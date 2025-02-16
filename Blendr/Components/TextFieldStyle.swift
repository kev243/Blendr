//
//  TextFieldStyle.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-08.
//

import Foundation
import SwiftUI

struct TextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(13)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.vertical,10)
    }
}


