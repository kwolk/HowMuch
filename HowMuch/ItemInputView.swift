//
//  ItemInputView.swift
//  HowMuch
//
//  Created by Samuel Corke on 28/03/2024.
//

import SwiftUI


// ENTERING DATA FOR FOODSTUFFS
struct ItemInputView: View {
    
    @Binding var item: Item
    @State private var price: Double = 0
    @State private var weight: Double = 0
    let onDelete: () -> Void    // DELETION ACTION
    
    
    init(item: Binding<Item>, onDelete: @escaping () -> Void) {
        self._item = item           // TWO-WAY-BINDING TO SOURCE OF TRUTH THAT UPDATES THE VIEW IN REAL TIME
        self.onDelete = onDelete    // EXECUTES THE FUNCTION (DELETE) OF WHICH TAKES NO PARAMETERS
    }

    var body: some View {
        VStack {
            
            // TOP BAR WITH ITEM NUMBER AND DELETE OPTION
            HStack {
                Text("Item #\(item.number)")
                Spacer()
                Button { onDelete() } label: { Image(systemName: "trash") }
            }
            .foregroundColor(.white)
            .font(.headline)
            .padding(10)
            
            // DISPLAYS PRICE (FORMATTED TO CURRENCY : GBP)
            HStack {
                TextField("Price", value: $price, formatter: currencyFormatter)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 10)
            }
            .onChange(of: price) { _ in updateBestValue() }  // UPDATE BEST VALUE ON CHANGE

            // DISPLAY WEIGHT DATA TO TWO DECIMAL PLACES (METRIC)
            HStack {
                TextField("Weight", value: $weight, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
            }
            .onChange(of: weight) { _ in updateBestValue() }
            
            // DISPLAY COST PER GRAM, OR WHICH DATA FIELD HAS NOT BEEN EDITED
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 35)
                        .cornerRadius(5)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)

                    Text(calculateTotal())
                        .foregroundColor(.black)
                        .font(.callout)
                        .padding(.bottom, 5)
                }
            }
        }
        .background(Color.red)
        .cornerRadius(15)
    }
    
    // FORMAT THE NUMBERS TO REPRESENT BRITISH CURRENCY : "£0.00"
    // THIS MAKES IT ANNOYING TO ENTER DATA AS THE EXISTING DATA MUST BE DELETED AND IF THE "£" IS OMMITTED IT RESETS TO "£0.00"
    private var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "£"
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    // CALCULATE THE TOTAL BASED ON A SIMPLE DIVISON OF THE PRICE BY THE WEIGHT OF THE ITEM
    private func calculateTotal() -> String {
        
        // A LITTLE IN-ELEGANT, BUT IT WORKS
        let priceIsNotEmpty = (price != 0)
        let weightIsNotEmpty = (weight != 0)
        
        // DETERMINE MISSING DATA TO DIRECT USER
        if priceIsNotEmpty && weightIsNotEmpty {
            let totalPrice = calculateBestValue(fromPrice: price, fromWeight: weight)
            return "Total: \(totalPrice)"
        } else if priceIsNotEmpty {
            return "Weight Unknown ?"
        } else if weightIsNotEmpty {
            return "Price Unknown ?"
        }
        return "Total: ?"   // DEFAULT VALUE
    }
    
    // CALCULATE VALUE FROM PRICE
    private func calculateBestValue(fromPrice price: Double, fromWeight weight: Double) -> String {
        let totalPence = Int(price * 100) // WORKAROUND : CONVERT POUNDS TO PENCE (ELSE IT TAKES THE VALUE AS A DECIMAL)
        let formattedPricePerGram = String(format: "%.0f", Double(totalPence) / weight) // REDUCE TO TWO DECIMAL PLACES
        return "\(formattedPricePerGram)p"
    }
    
    // UPDATE THE BEST VALUE DATA BY DIVDING THE GRAMMAGE FROM THE PRICE
    private func updateBestValue() {
        guard price != 0, weight != 0 else { return }
        let totalPence = Int(price * 100)
        let pricePerGram = Double(totalPence) / weight
        item.bestValue = pricePerGram
    }
}
