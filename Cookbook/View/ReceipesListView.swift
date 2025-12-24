//
//  ReceipesListView.swift
//  Cookbook
//
//  Created by Meggi on 24/12/25.
//
import SwiftUI

struct RecipesListView: View {
    @State private var searchText = ""
    @State private var isShowingAddSheet = false
    @Environment(CookbookManager.self) private var manager
    
    var filteredRecipes: [Recipe] {
        searchText.isEmpty ? manager.recipes : manager.recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredRecipes) { recipe in
                // NavigationLink works now that Recipe is Hashable
                NavigationLink(value: recipe) {
                    Text(recipe.name)
//                    RecipeRow(recipe: recipe)
                }
            }
            .navigationTitle("Cookbook")
            .searchable(text: $searchText)
            .toolbar {
                Button {
                    isShowingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .sheet(isPresented: $isShowingAddSheet) {
                 AddRecipeView()
            }
        }
        .tint(Color(hex: "#011993"))
    }
}
