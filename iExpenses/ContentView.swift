//
//  ContentView.swift
//  iExpenses
//
//  Created by Vegesna, Vijay V EX1 on 2/22/20.
//  Copyright © 2020 Vegesna, Vijay V EX1. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: String
    var amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoding = JSONEncoder()
            
            if let encoded = try? encoding.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "items") {
        let decoding = JSONDecoder()
            if let decoded = try? decoding.decode([ExpenseItem].self, from: items) {
            self.items = decoded
            return
            }
        }
        self.items = []
    }
}

struct applyTextColor: ViewModifier {
    var amount: Int
    func body(content: Content) -> some View {
        content
            .foregroundColor( (amount < 10) ? .red : .blue)
    }
}

extension View {
    func applyStyling(for amount: Int) -> some View {
        return self.modifier(applyTextColor(amount: amount))
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State var presentAddExpanse = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("\(item.amount)$")
                        .applyStyling(for: item.amount)
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.presentAddExpanse = true
            }) {
                Image(systemName: "plus")
            })
                .sheet(isPresented: $presentAddExpanse) {
                    AddExpanse(expenses: self.expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
