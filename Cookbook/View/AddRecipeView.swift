//
//  AddRecipeView.swift
//  Cookbook
//
//  Created by Meggi on 24/12/25.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(CookbookManager.self) private var manager
    
    // Recipe Basic Info
    @State private var name = ""
    @State private var description = ""
    @State private var instructions = ""
    
    // Media URLs (Requirement: Image/Video Optional)
    @State private var imageURL = ""
    @State private var videoURL = ""
    
    // Ingredient Selection State
    @State private var selectedIngredients: [RecipeIngredient] = []
    @State private var isShowingIngredientPicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("General Information") {
                    TextField("Recipe Name", text: $name)
                    TextField("Short Description", text: $description)
                }
                
                Section("Media (Optional)") {
                    TextField("Image URL", text: $imageURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    
                    TextField("Video URL", text: $videoURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
                
                Section("Ingredients") {
                    ForEach(selectedIngredients, id: \.ingredientId) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("\(item.quantity, specifier: "%.1f") \(item.unit)")
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete { indices in
                        selectedIngredients.remove(atOffsets: indices)
                    }
                    
                    Button {
                        isShowingIngredientPicker = true
                    } label: {
                        Label("Add Ingredient", systemImage: "plus.circle")
                    }
                }
                
                Section("Instructions") {
                    TextEditor(text: $instructions)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .disabled(name.isEmpty || selectedIngredients.isEmpty)
                }
            }
            .sheet(isPresented: $isShowingIngredientPicker) {
                IngredientPickerView(selectedIngredients: $selectedIngredients)
            }
        }
    }
    
    private func saveRecipe() {
        // Cleaning optional strings: if empty, set to nil
        let img = imageURL.trimmingCharacters(in: .whitespaces).isEmpty ? nil : imageURL
        let vid = videoURL.trimmingCharacters(in: .whitespaces).isEmpty ? nil : videoURL
        
        let newRecipe = Recipe(
            name: name,
            description: description,
            ingredients: selectedIngredients,
            instructions: instructions,
            imageURL: img,
            videoURL: vid
        )
        
        Task {
            await manager.addRecipe(newRecipe)
            dismiss()
        }
    }
}


// A helper view to select ingredients from the Pantry
struct IngredientPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(CookbookManager.self) private var manager
    
    @Binding var selectedIngredients: [RecipeIngredient]
    
    @State private var quantity: String = ""
    @State private var selectedBaseIngredient: Ingredient?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Select from Pantry") {
                    Picker("Ingredient", selection: $selectedBaseIngredient) {
                        Text("Select one").tag(nil as Ingredient?)
                        ForEach(manager.ingredients) { ingredient in
                            Text(ingredient.name).tag(ingredient as Ingredient?)
                        }
                    }
                }
                
                if let selected = selectedBaseIngredient {
                    Section("Quantity") {
                        HStack {
                            TextField("Amount", text: $quantity)
                                .keyboardType(.decimalPad)
                            Text(selected.measurementUnit)
                        }
                    }
                }
            }
            .navigationTitle("Add Ingredient")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let base = selectedBaseIngredient, let qty = Double(quantity) {
                            let newRecipeItem = RecipeIngredient(
                                ingredientId: base.id ?? "",
                                name: base.name,
                                quantity: qty,
                                unit: base.measurementUnit
                            )
                            selectedIngredients.append(newRecipeItem)
                            dismiss()
                        }
                    }
                    .disabled(selectedBaseIngredient == nil || quantity.isEmpty)
                }
            }
        }
    }
}
