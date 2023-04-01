//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Ankur Kalson on 2023-03-29.
//

import Foundation
import SwiftUI

extension Color {
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
    
}

extension DateFormatter {
    static let allNumeric: DateFormatter = {
        print("Initializing DateFormater")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    }()
}

extension String {
    func dateParse() -> Date {
        guard let parseDate = DateFormatter.allNumeric.date(from: self) else {
            return Date()
        }
        
        return parseDate
    }
}

extension Date: Strideable {
    func formatted() -> String {
        return self.formatted(.dateTime.year().month().day())
    }
}
