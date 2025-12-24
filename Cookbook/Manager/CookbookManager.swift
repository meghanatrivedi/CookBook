//
//  CookbookManager.swift
//  Cookbook
//
//  Created by Meggi on 24/12/25.
//

import SwiftUI
import FirebaseFirestore

@Observable
class CookbookManager {
    var recipes: [Recipe] = []
    var ingredients: [Ingredient] = []
    private let db = Firestore.firestore()
    
    init() { Task { await fetchAll() } }
    
    @MainActor
    func fetchAll() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchIngredients() }
            group.addTask { await self.fetchRecipes() }
        }
    }
    
    @MainActor
    func fetchIngredients() async {
        do {
            let snapshot = try await db.collection("ingredients").getDocuments()
            self.ingredients = snapshot.documents.compactMap { try? $0.data(as: Ingredient.self) }
        } catch { print("Firestore Error: \(error)") }
    }
    
    @MainActor
    func fetchRecipes() async {
        do {
            let snapshot = try await db.collection("recipes").getDocuments()
            self.recipes = snapshot.documents.compactMap { try? $0.data(as: Recipe.self) }
        } catch { print("Firestore Error: \(error)") }
    }

    func matchRecipes(for ingredientIds: Set<String>) -> [Recipe] {
        guard !ingredientIds.isEmpty else { return [] }
        return recipes.filter { recipe in
            let recipeIds = Set(recipe.ingredients.map { $0.ingredientId })
            return recipeIds.isSubset(of: ingredientIds)
        }
    }

    func addRecipe(_ recipe: Recipe) async {
        try? db.collection("recipes").addDocument(from: recipe)
        await fetchRecipes()
    }

    func deleteRecipe(_ recipe: Recipe) async {
        guard let id = recipe.id else { return }
        try? await db.collection("recipes").document(id).delete()
        await fetchRecipes()
    }

    func addIngredient(_ ingredient: Ingredient) async {
        try? db.collection("ingredients").addDocument(from: ingredient)
        await fetchIngredients()
    }

    func deleteIngredient(_ ingredient: Ingredient) async {
        guard let id = ingredient.id else { return }
        try? await db.collection("ingredients").document(id).delete()
        await fetchIngredients()
    }
}
