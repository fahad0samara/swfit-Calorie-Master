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
    @State private var protein: Double = 0
    @State private var fat: Double = 0
    @State private var carbohydrates: Double = 0
    @State private var selectedCategoryIndex = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Details")) {
                    TextField("Food Name", text: $name)
                        .padding(.vertical, 8)
                    
                    Picker("Category", selection: $selectedCategoryIndex) {
                        ForEach(0..<viewModel.categories.count, id: \.self) { index in
                            Text(viewModel.categories[index])
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Nutritional Information")) {
                    NutritionSliderView(title: "Protein", value: $protein)
                    NutritionSliderView(title: "Fat", value: $fat)
                    NutritionSliderView(title: "Carbohydrates", value: $carbohydrates)
                }
                
                Section(header: Text("Calories")) {
                    Slider(value: $calories, in: 0...3000, step: 50)
                        .padding(.horizontal)
                    Text("\(Int(calories)) kcal")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                }
                
                Section {
                    Button("Submit") {
                        let selectedCategory = viewModel.categories[selectedCategoryIndex]
                        viewModel.editFood(food: food, name: name, calories: calories, protein: protein, fat: fat, carbohydrates: carbohydrates, category: selectedCategory, context: managedObjectContext)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(FilledButtonStyle())
                }
            }
            .navigationTitle("Edit Food")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
        .onAppear {
            name = food.name ?? ""
            calories = food.calories
            protein = food.protein
            fat = food.fat
            carbohydrates = food.carbohydrates
            
            if let index = viewModel.categories.firstIndex(of: food.category ?? "") {
                selectedCategoryIndex = index
            }
        }
    }
}
