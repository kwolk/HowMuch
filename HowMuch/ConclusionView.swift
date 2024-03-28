//
//  ConclusionView.swift
//  HowMuch
//
//  Created by Samuel Corke on 28/03/2024.
//

import SwiftUI


// CONVENIENT VIEW DISPLAYING THE CHEAPEST OPTION FROM ALL ITEMS BY COMPARRING THEIR RELATIVE BEST VALUES
struct ConclusionView: View {
    var boxes: [Item]
    
    var body: some View {
        VStack {
            Text("Best Value")
                .padding()
            ZStack {
                Rectangle()
                    .fill(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                    .cornerRadius(5)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)

                if let cheapestItem = boxes.min(by: { $0.bestValue < $1.bestValue }) {  // COMPARE BEST VALUES FROM ALL ITEMS
                    Text("Item #\(cheapestItem.number)")
                        .foregroundColor(.black)
                        .font(.callout)
                        .padding(.bottom, 10)
                } else {
                    // LETS USER KNOW TO ADD AN ITEM WITH BUTTON AT THE BOTTOM OF THE VIEW
                    Text("No items, press 'Add Item' below")
                        .foregroundColor(.black)
                        .font(.callout)
                        .padding(.bottom, 10)
                }
            }
        }
        .foregroundColor(.white)
        .font(.headline)
        .frame(maxWidth: .infinity)
        .background(.red)
        .cornerRadius(15)
        .padding()
    }
}
