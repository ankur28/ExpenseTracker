//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Ankur Kalson on 2023-03-29.
//

import Foundation
import Combine
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getTransactions()
    }
    
    func getTransactions() {
       guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("INVALID URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode  == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) // recieve the response on main thread
            .sink { completion in //handling error
                switch completion {
                case .failure(let error): print("Error fetching transactions", error.localizedDescription)
                case .finished: print("Finished fetching transaction")
                }
            } receiveValue: { [weak self] result in // weak self will help in prevent memory leak
                self?.transactions = result
            }
            .store(in: &cancellables) //it will cancell the subscription when reference gets deallocated thus free up resources

    }
    
    func groupTransactionByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else {
            return [:]
        }
        
        // grouping transactions by its months
        let groupedTransactions =   TransactionGroup(grouping: transactions) { $0.month}
        print("grouped: \(groupedTransactions)")
        return groupedTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum{
        print("AccUmuluatetransactions")
        guard !transactions.isEmpty else { return []}
        
            // ideally it should be current date but data ends on feb 16
        let today = "02/17/2022".dateParse()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print(dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        
        //60 sec 60 mi 24 hr
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24){
            let dailyExpenses = transactions.filter{ $0.dateParsed == date && $0.isExpense }
            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
            
            sum += dailyTotal
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "dailyTotal: ", dailyTotal, "sum: ", sum)
        }
        return cumulativeSum
    }
}
