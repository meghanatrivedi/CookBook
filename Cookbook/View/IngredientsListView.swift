//
//  IngredientsListView.swift
//  Cookbook
//
//  Created by Meggi on 24/12/25.
//

import SwiftUI

struct IngredientsListView: View {
    @Environment(CookbookManager.self) private var manager
    @State private var searchText = ""
    @State private var isShowingAddSheet = false
    
    // Filtered results based on search text
    var filteredIngredients: [Ingredient] {
        if searchText.isEmpty {
            return manager.ingredients
        } else {
            return manager.ingredients.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredIngredients) { ingredient in
                    HStack {
                        // Optional Image placeholder using native SF Symbols
                        Image(systemName: "tag.circle.fill")
                            .foregroundColor(Color(hex: "#011993"))
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(ingredient.name)
                                .font(.headline)
                            Text("Unit: \(ingredient.measurementUnit)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteIngredients)
            }
            .navigationTitle("Pantry")
            .searchable(text: $searchText, prompt: "Search ingredients")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // Sheet to add a new ingredient
            .sheet(isPresented: $isShowingAddSheet) {
                AddIngredientView()
            }
        }
    }
    
    private func deleteIngredients(at offsets: IndexSet) {
        for index in offsets {
            let ingredient = filteredIngredients[index]
            Task {
                await manager.deleteIngredient(ingredient)
            }
        }
    }
}

// Separate View for Adding Ingredients to keep code clean
struct AddIngredientView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(CookbookManager.self) private var manager
    
    @State private var name = ""
    @State private var unit = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Ingredient Details") {
                    TextField("Name", text: $name)
                    TextField("Measurement Unit (e.g. kg, grams, pcs)", text: $unit)
                }
            }
            .navigationTitle("New Ingredient")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newIngredient = Ingredient(name: name, measurementUnit: unit)
                        Task {
                            await manager.addIngredient(newIngredient)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty || unit.isEmpty)
                }
            }
        }
    }
}
