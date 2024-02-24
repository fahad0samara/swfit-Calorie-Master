//
//  EditFoodView.swift
//  swfit-Calorie-Master
//
//  Created by fahad samara on 2/23/24.

import SwiftUI

struct EditFoodView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    var food: FoodEntity
    
    @ObservedObject var viewModel: CoreDataViewModel
    
    @State private var name = ""
    @State private var calories: Double = 0
    
    var body: some View {
        Form {
            Section {
                TextField("Food Name", text: $name)
                    .onAppear {
                        name = food.name ?? ""
                        calories = food.calories
                    }
                
                VStack {
                    Text("Calories \(Int(calories))")
                    Slider(value: $calories, in: 0...3000, step: 50)
                }
                
                HStack {
                    Spacer()
                    Button("Submit") {
                        viewModel.editFood(food: food, name: name, calories: calories, context: managedObjectContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}
