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
    @State private var nutritionalInfo: NutritionalInfo? = nil
    
    private let nutritionAPI = NutritionAPI()
    
    var body: some View {
        Form {
            Section {
                TextField("Food Name", text: $name)
                    .onReceive(Just(name)) { newName in
                        fetchNutritionalInfo(for: newName)
                    }
                
                if let nutritionalInfo = nutritionalInfo {
                    VStack {
                        Text("Calories: \(nutritionalInfo.calories)")
                        Text("Protein: \(nutritionalInfo.protein)")
                        Text("Fat: \(nutritionalInfo.fat)")
                        Text("Carbohydrates: \(nutritionalInfo.carbohydrates)")
                    }
                }
            }
            
            VStack {
                Text("Calories \(Int(calories))")
                Slider(value: $calories, in: 0...3000, step: 50)
            }
            
            HStack {
                Spacer()
                Button("Submit") {
                    viewModel.addFood(name: name, calories: calories, context: managedObjectContext)
                    dismiss()
                }
                Spacer()
            }
        }
    }
    
    private func fetchNutritionalInfo(for foodName: String) {
        nutritionAPI.fetchNutritionalInformation(for: foodName) { info in
            DispatchQueue.main.async {
                nutritionalInfo = info
            }
        }
    }
}
