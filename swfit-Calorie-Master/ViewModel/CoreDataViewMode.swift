//
//  CoreDataViewMode.swift
//  swfit-Calorie-Master
//
//  Created by fahad samara on 2/23/24.
//

import Foundation
import CoreData

class CoreDataViewModel: ObservableObject {
    let container = NSPersistentContainer(name: "FoodItem")
    
    @Published var food: [FoodEntity] = []
    @Published var totalCaloriesToday: Double = 0
    
       let categories = ["Vegetables", "Fruits", "Proteins", "Grains", "Dairy", "Sweets", "Beverages"]

    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
        fetchFood()
    }
    
    func groupedFoodByDay() -> [[FoodEntity]] {
          let groupedDictionary = Dictionary(grouping: food) { (foodEntity) -> Date in
              guard let date = foodEntity.data else { return Date() }
              let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
              return Calendar.current.date(from: components) ?? Date()
          }
          return groupedDictionary.sorted { $0.key > $1.key }.map { $0.value }
      }
    
    func fetchFood() {
        let request: NSFetchRequest<FoodEntity> = FoodEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FoodEntity.data, ascending: false)]
        
        do {
            food = try container.viewContext.fetch(request)
            updateTotalCalories()
            print("Fetched food: \(food)")
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved")
            fetchFood()
        } catch {
            print("Unable to save data")
        }
    }
    
    func addFood(name: String, calories: Double, protein: Double, fat: Double, carbohydrates: Double, category: String, context: NSManagedObjectContext) {
        let food = FoodEntity(context: context)
        food.id = UUID()
        food.name = name
        food.calories = calories
        food.protein = protein
        food.fat = fat
        food.carbohydrates = carbohydrates
        food.category = category
        food.data = Date()
        
        save(context: context)
    }

    func editFood(food: FoodEntity, name: String, calories: Double, protein: Double, fat: Double, carbohydrates: Double, category: String, context: NSManagedObjectContext) {
        food.name = name
        food.data = Date()
        food.calories = calories
        food.protein = protein
        food.fat = fat
        food.carbohydrates = carbohydrates
        food.category = category
        
        save(context: context)
    }

    
    // these fun for delete
    
    func deleteFood(atOffsets offsets: IndexSet) {
        offsets.forEach { index in
            let foodToDelete = food[index]
            container.viewContext.delete(foodToDelete)
        }
        save(context: container.viewContext)
    }
    // these fun for update
    private func updateTotalCalories() {
        totalCaloriesToday = food.reduce(0.0) { result, item in
            if Calendar.current.isDateInToday(item.data ?? Date()) {
                return result + item.calories
            } else {
                return result
            }
        }
    }
    
    func totalProteinToday() -> Double {
            var proteinToday: Double = 0
            for item in food {
                if Calendar.current.isDateInToday(item.data ?? Date()) {
                    proteinToday += item.protein
                }
            }
            return proteinToday
        }

        func totalFatToday() -> Double {
            var fatToday: Double = 0
            for item in food {
                if Calendar.current.isDateInToday(item.data ?? Date()) {
                    fatToday += item.fat
                }
            }
            return fatToday
        }

        func totalCarbohydratesToday() -> Double {
            var carbohydratesToday: Double = 0
            for item in food {
                if Calendar.current.isDateInToday(item.data ?? Date()) {
                    carbohydratesToday += item.carbohydrates
                }
            }
            return carbohydratesToday
        }
}
