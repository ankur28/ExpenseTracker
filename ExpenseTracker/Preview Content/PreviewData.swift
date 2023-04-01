//
//  PreviewData.swift
//  ExpenseTracker
//
//  Created by Ankur Kalson on 2023-03-29.
//

import Foundation

var transactionPreviewData = Transaction(id: 1, date: "01/24/2023", institution: "NoFrills", account: "Visa", merchant: "Apple", amount: 22.12, type: "debit", categoryId: 801, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
