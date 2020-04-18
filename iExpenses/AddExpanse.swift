//
//  AddExpanse.swift
//  iExpenses
//
//  Created by Vegesna, Vijay V EX1 on 2/22/20.
//  Copyright © 2020 Vegesna, Vijay V EX1. All rights reserved.
//

import SwiftUI

struct AddExpanse: View {
    @Environment (\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    static let types = ["Personal", "Business"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter name:", text: $name)
                Picker("select type", selection: $type) {
                    ForEach(Self.types, id:\.self) {
                        Text($0)
                    }
                }
                TextField("Enter amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add New Expanse")
            .navigationBarItems(trailing: Button("Save") {
                if let entredAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: entredAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct AddExpanse_Previews: PreviewProvider {
    static var previews: some View {
        AddExpanse(expenses: Expenses())
    }
}
