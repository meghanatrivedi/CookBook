//
//  ContentView.swift
//  Cookbook
//
//  Created by Meggi on 24/12/25.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? color : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}
