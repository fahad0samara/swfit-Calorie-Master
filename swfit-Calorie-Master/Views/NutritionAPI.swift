//
//  NutritionAPI.swift
//  swfit-Calorie-Master
//
//  Created by fahad samara on 2/23/24.
//

import SwiftUI

import Foundation

class NutritionAPI {
    let apiKey = "458338911570cadccbb11bb5931297bf"
    let baseURL = "https://api.nutritionix.com/v1_1/"
    
    func fetchNutritionalInformation(for foodName: String, completion: @escaping (NutritionalInfo?) -> Void) {
        let encodedFoodName = foodName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)search/\(encodedFoodName)?results=0%3A1&fields=item_name%2Cnf_calories%2Cnf_protein%2Cnf_total_fat%2Cnf_total_carbohydrate&appId=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NutritionAPIResponse.self, from: data)
                if let foodItem = response.hits.first?.fields {
                    let nutritionalInfo = NutritionalInfo(calories: foodItem.nfCalories, protein: foodItem.nfProtein, fat: foodItem.nfTotalFat, carbohydrates: foodItem.nfTotalCarbohydrate)
                    completion(nutritionalInfo)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

struct NutritionAPIResponse: Codable {
    let hits: [FoodHit]
}

struct FoodHit: Codable {
    let fields: FoodItem
}

struct FoodItem: Codable {
    let itemName: String
    let nfCalories: Double
    let nfProtein: Double
    let nfTotalFat: Double
    let nfTotalCarbohydrate: Double
}

struct NutritionalInfo {
    let calories: Double
    let protein: Double
    let fat: Double
    let carbohydrates: Double
}


