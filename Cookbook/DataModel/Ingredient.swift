//
//  Ingredient.swift
//  Cookbook
//
//  Created by Meggi on 24/12/25.
//

import Foundation
import FirebaseFirestore

struct Ingredient: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var name: String
    var measurementUnit: String
    var imageURL: String?
}

struct RecipeIngredient: Codable, Hashable {
    var ingredientId: String
    var name: String
    var quantity: Double
    var unit: String
}

struct Recipe: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var ingredients: [RecipeIngredient]
    var instructions: String
    var imageURL: String?
    var videoURL: String?

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Recipe, rhs: Recipe) -> Bool { lhs.id == rhs.id }
}
