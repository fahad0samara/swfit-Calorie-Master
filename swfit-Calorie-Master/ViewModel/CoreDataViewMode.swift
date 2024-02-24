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
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
        fetchFood()
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
    
    func addFood(name: String, calories: Double, context: NSManagedObjectContext) {
        let food = FoodEntity(context: context)
        food.id = UUID()
        food.name = name
        food.calories = calories
        food.data = Date()
        
        save(context: context)
    }
    
    func editFood(food: FoodEntity, name: String, calories: Double, context: NSManagedObjectContext) {
        food.name = name
        food.data = Date()
        food.calories = calories
        
        save(context: context)
    }
    
    func deleteFood(atOffsets offsets: IndexSet) {
        offsets.forEach { index in
            let foodToDelete = food[index]
            container.viewContext.delete(foodToDelete)
        }
        save(context: container.viewContext)
    }
    
    private func updateTotalCalories() {
        totalCaloriesToday = food.reduce(0.0) { result, item in
            if Calendar.current.isDateInToday(item.data ?? Date()) {
                return result + item.calories
            } else {
                return result
            }
        }
    }
}
