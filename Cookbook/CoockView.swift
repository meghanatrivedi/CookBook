//
//  CoockView.swift
//  Cookbook
//
//  Created by Meggi on 24/12/25.
//


import SwiftUI

struct CookView: View {
    @Environment(CookbookManager.self) private var manager
    @State private var selectedIngredients = Set<String>()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(manager.ingredients) { ingredient in
                            FilterChip(
                                title: ingredient.name,
                                isSelected: selectedIngredients.contains(ingredient.id ?? ""),
                                color: Color(hex: "#011993")
                            ) {
                                if let id = ingredient.id {
                                    if selectedIngredients.contains(id) { selectedIngredients.remove(id) }
                                    else { selectedIngredients.insert(id) }
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                List(manager.matchRecipes(for: selectedIngredients)) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        VStack(alignment: .leading) {
                            Text(recipe.name).font(.headline)
                            Text("\(recipe.ingredients.count) ingredients").font(.caption)
                        }
                    }
                }
                .overlay {
                    if selectedIngredients.isEmpty {
                        ContentUnavailableView("Select Ingredients", systemImage: "basket", description: Text("Pick items to see recipes."))
                    } else if manager.matchRecipes(for: selectedIngredients).isEmpty {
                        ContentUnavailableView("No Matches", systemImage: "magnifyingglass", description: Text("Try adding more items."))
                    }
                }
            }
            .navigationTitle("Cook")
        }
    }
}
