//
//  ContentView.swift
//  swfit-Calorie-Master
//
//  Created by fahad samara on 2/23/24.
//
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
