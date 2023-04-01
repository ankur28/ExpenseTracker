//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Ankur Kalson on 2023-03-29.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
   @StateObject var transactionListVM = TransactionListViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
