//
//  swfit_Calorie_MasterApp.swift
//  swfit-Calorie-Master
//
//  Created by fahad samara on 2/23/24.
//

import SwiftUI

@main
struct swfit_Calorie_MasterApp: App {
    @StateObject private var viewModel = CoreDataViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, viewModel.container.viewContext)

        }
    }
}
