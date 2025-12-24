//
//  RecipeDetailView.swift
//  Cookbook
//
//  Created by Meggi on 24/12/25.
//


import SwiftUI
import AVKit // Required for Video playback

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        List {
            // Optional Image Section
            if let urlString = recipe.imageURL, let url = URL(string: urlString) {
                Section {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 200)
                    .listRowInsets(EdgeInsets())
                }
            }
            
            Section("Description") {
                Text(recipe.description)
            }
            
            // Optional Video Section
            if let vidString = recipe.videoURL, let url = URL(string: vidString) {
                Section("Tutorial Video") {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(height: 200)
                }
            }
            
            Section("Ingredients") {
                ForEach(recipe.ingredients, id: \.ingredientId) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.quantity, specifier: "%.1f") \(item.unit)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section("Instructions") {
                Text(recipe.instructions)
            }
        }
        .navigationTitle(recipe.name)
    }
}
