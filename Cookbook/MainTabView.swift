//
//  MainTabView.swift
//  Cookbook
//
//  Created by Meggi on 24/12/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var manager = CookbookManager()
    let themeColor = Color(hex: "#011993")
    
    var body: some View {
        TabView {
            RecipesListView()
                .tabItem { Label("Recipes", systemImage: "book.fill") }
            
            IngredientsListView()
                .tabItem { Label("Pantry", systemImage: "carrot.fill") }
            
            CookView()
                .tabItem { Label("Cook", systemImage: "stove.fill") }
        }
        .environment(manager)
        .tint(themeColor)
    }
}
