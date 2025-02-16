//
//  VmTab.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-17.
//

import Foundation

class VmTab : ObservableObject {
    static let shared = VmTab()
    @Published private var selectedTab = 0
}
