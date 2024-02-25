//
//  AddFoodView.swift
//  swfit-Calorie-Master
//
//  Created by fahad samara on 2/23/24.
//

import SwiftUI
import SwiftUI
import Combine

struct AddFoodView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
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
                        viewModel.addFood(name: name, calories: calories, protein: protein, fat: fat, carbohydrates: carbohydrates, category: selectedCategory, context: managedObjectContext)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(FilledButtonStyle())
                }
            }
            .navigationTitle("Add Food")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
}

struct NutritionSliderView: View {
    var title: String
    @Binding var value: Double
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Slider(value: $value, in: 0...100, step: 1)
                .padding(.horizontal)
            Text("\(Int(value)) g")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 40)
        }
    }
}

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.blue.opacity(0.7) : Color.blue)
            .cornerRadius(8)
    }
}
