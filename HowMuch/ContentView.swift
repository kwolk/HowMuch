//
//  ContentView.swift
//  HowMuch
//
//  Created by Samuel Corke on 26/03/2024.
//


import SwiftUI

// FOODSTUFFS ITEM
struct Item         : Identifiable {
    var id          : UUID
    var number      : Int
    var bestValue   : Double = 0
}


struct ContentView: View {
    @State var items    : [Item] = []
    @State var counter  : Int = 1     // NUMBER OF ITEMS
    
    var body: some View {
        
        ConclusionView(boxes: items)    // PERMANENT CONCLUSION AT TOP OF VIEW : DISPLAYING BEST VALUE COMBO FOR QUICK REFERENCE
        Spacer()
        addButton
    }
    
    // ITEM : BUTTON TO ADD NEW ITEM INTO VIEW
    var addButton: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        ForEach(items.indices, id: \.self) { index in
                            ItemInputView(item: $items[index], onDelete: {
                                self.removeItem(at: index)
                            })
                        }
                    }
                }
            Button {
                self.addItem()
            } label: {
                Text("Add Item")
            }
            .foregroundColor(.white)
            .padding(.horizontal, 15)
            .font(.headline)
            .background(.red)
            .cornerRadius(15)
            }
        }
        .padding()
        // HIDE SCROLL-BARS (VERTICAL)
        .onAppear(perform: { UIScrollView.appearance().showsVerticalScrollIndicator = false })
        // HIDE KEYBOARD : TAP ANYWHERE
        .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
        // HIDE KEYBOARD : ON SWIPE (A LITTLE BUGGY AS IT ONLY LOOKS FOR GESTURES ON THIS VIEW)
        .gesture(DragGesture().onChanged { _ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) })
    }
    
    // ITEM : ADD TO ITEMS ARRAY
    private func addItem() {
        let item = Item(id: UUID(), number: counter)
        items.append(item)
        counter += 1
    }
    
    // ITEM : DELETE
    private  func removeItem(at index: Int) {
        items.remove(at: index)
    }
}

