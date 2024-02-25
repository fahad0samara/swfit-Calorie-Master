//
//  FoodDetailView.swift
//  swfit-Calorie-Master
//
//  Created by fahad samara on 2/25/24.
//
import SwiftUI



import SwiftUI

struct FoodDetailView: View {
    let food: FoodEntity
    @ObservedObject var viewModel = CoreDataViewModel()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    Text(food.name ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("\(Int(food.calories)) calories")
                        .foregroundColor(.red)
                        .font(.headline)
                    
                    Text("Nutritional Information:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // Display nutritional values with corresponding icons
                    HStack(spacing: 80) {
                        NutritionalInfoView(title: "Protein", value: Int(food.protein), color: .blue, icon: "bolt.fill")
                        NutritionalInfoView(title: "Fat", value: Int(food.fat), color: .green, icon: "drop.fill")
                        NutritionalInfoView(title: "Carbs", value: Int(food.carbohydrates), color: .orange, icon: "leaf.fill")
                    }
                    
                    
                    // Example of a basic chart (you can replace this with your custom chart)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nutritional Distribution")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 20) {
                            BarChart(value: CGFloat(food.protein), color: .blue, label: "Protein")
                            BarChart(value: CGFloat(food.fat), color: .green, label: "Fat")
                            BarChart(value: CGFloat(food.carbohydrates), color: .orange, label: "Carbs")
                        }
                    }
                    Spacer()
                }
                .padding()
                .navigationBarTitle("Food Details", displayMode: .inline)
                .overlay(
                // Floating button
                NavigationLink(destination: EditFoodView(food: food, viewModel: viewModel)) {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .padding()
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
                , alignment: .bottomTrailing
                )
            }
        }
    }
}


// Example BarChart view
struct BarChart: View {
    var value: CGFloat
    var color: Color
    var label: String

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.2))
                    .frame(height: 100)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(height: value)
            }
        }.padding(.horizontal)
    }
}

// View for displaying nutritional information with icons
struct NutritionalInfoView: View {
    var title: String
    var value: Int
    var color: Color
    var icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 30))
            
            Text("\(value)g")
                .font(.title)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
