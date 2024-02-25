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

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Nutrition")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    NutritionSummaryView(title: "Calories", value: Int(viewModel.totalCaloriesToday), color: .gray)
                    NutritionSummaryView(title: "Protein", value: Int(viewModel.totalProteinToday()), color: .blue)
                    NutritionSummaryView(title: "Fat", value: Int(viewModel.totalFatToday()), color: .green)
                    NutritionSummaryView(title: "Carbohydrates", value: Int(viewModel.totalCarbohydratesToday()), color: .orange)
                }
                .padding(.horizontal)
                
                List {
                    ForEach(viewModel.food) { food in
                        NavigationLink(destination: EditFoodView(food: food, viewModel: viewModel)) {
                            FoodListItemView(food: food)
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddFoodView.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showAddFoodView) {
                AddFoodView(viewModel: viewModel)
            }
        }
    }
    
    func deleteFood(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteFood(atOffsets: offsets)
        }
    }
}

struct NutritionSummaryView: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text("\(title):")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text("\(value)")
                .font(.headline)
                .foregroundColor(color)
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
                Text("\(Int(food.calories)) calories")
                    .font(.subheadline)
                    .foregroundColor(.red)
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
