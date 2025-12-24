//
//  Extensions.swift.swift
//  Cookbook
//
//  Created by Meggi on 24/12/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int & 0xff0000) >> 16) / 255
        let g = Double((int & 0x00ff00) >> 8) / 255
        let b = Double(int & 0x0000ff) / 255
        self.init(red: r, green: g, blue: b)
    }
}
