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
            VStack(alignment: .leading, spacing: 8) {
                Text("\(Int(viewModel.totalCaloriesToday)) Kcal Today").foregroundColor(.gray)
                    .padding(.horizontal)

                List {
                    ForEach(viewModel.food) { food in
                        NavigationLink(destination: EditFoodView(food: food, viewModel: viewModel)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(food.name ?? "").bold()
                                    Text("\(Int(food.calories)) calories").foregroundColor(.red)
                                }
                                Spacer()
                                Text(calcTimeSince(data: food.data!))
                                    .foregroundColor(.orange)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
            }
            .navigationTitle("Calories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddFoodView.toggle()
                    }) {
                        Label("Add Food", systemImage: "plus.circle")
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
