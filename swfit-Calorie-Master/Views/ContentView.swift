//
//  ContentView.swift
//  swfit-Calorie-Master
//
//  Created by fahad samara on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject var viewModel = CoreDataViewModel()
    @State private var showAddFoodView = false
    @State private var selectedFood: FoodEntity?

    
    

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today's Nutrition")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 25) {
                        
                        NutritionSummaryView(title: "Calories", value: Int(viewModel.totalCaloriesToday), color: .gray, icon: "flame.fill")
                        NutritionSummaryView(title: "Protein", value: Int(viewModel.totalProteinToday()), color: .blue, icon: "bolt.fill")
                        NutritionSummaryView(title: "Fat", value: Int(viewModel.totalFatToday()), color: .green, icon: "drop.fill")
                        NutritionSummaryView(title: "Carbohydrates", value: Int(viewModel.totalCarbohydratesToday()), color: .orange, icon: "leaf.fill")
                    }
                }
                .padding(.horizontal)
                
                List {
                    ForEach(viewModel.food) { food in
                        NavigationLink(destination: FoodDetailView(food: food), tag: food, selection: $selectedFood) {
                            FoodListItemView(food: food)
                                .onTapGesture {
                                    selectedFood = food
                                }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
            }

            .toolbar {
    
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .overlay(
            // Floating button
            NavigationLink(destination:AddFoodView(viewModel: viewModel)) {
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
    
    func deleteFood(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteFood(atOffsets: offsets)
        }
    }
}

// NutritionSummaryView for displaying nutritional summary information
struct NutritionSummaryView: View {
    var title: String
    var value: Int
    var color: Color
    var icon: String

    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 36))
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text("\(value)")
                .font(.title2) // Larger font size
                .foregroundColor(.primary)
        }
    }
}

struct FoodListItemView: View {
    let food: FoodEntity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(food.name ?? "")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(food.category ?? "")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
            Spacer()
            Text(calcTimeSince(data: food.data!))
                .font(.subheadline)
                .foregroundColor(.orange)
                .italic()
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}





func calcTimeSince(data: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: data, to: now)
    
    if let year = components.year, year > 0 {
        return "\(year) year\(year == 1 ? "" : "s") ago"
    } else if let month = components.month, month > 0 {
        return "\(month) month\(month == 1 ? "" : "s") ago"
    } else if let day = components.day, day > 0 {
        return "\(day) day\(day == 1 ? "" : "s") ago"
    } else if let hour = components.hour, hour > 0 {
        return "\(hour) hour\(hour == 1 ? "" : "s") ago"
    } else if let minute = components.minute, minute > 0 {
        return "\(minute) minute\(minute == 1 ? "" : "s") ago"
    } else {
        return "Just now"
    }
}
