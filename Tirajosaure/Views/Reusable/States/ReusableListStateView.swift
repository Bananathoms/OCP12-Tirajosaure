//
//  ReusableListStateView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 01/07/2024.
//

import SwiftUI

struct ReusableListStateView<Data: RandomAccessCollection, EmptyView: View, ContentView: View, DestinationView: View>: View where Data.Element: Identifiable {
    let data: Data
    let emptyView: EmptyView
    let contentView: ContentView
    let buttonText: String
    let buttonImage: Image
    let buttonColor: Color
    let textColor: Color
    let destinationView: DestinationView
    let navigateToAdd: Binding<Bool>
    let buttonAction: (() -> Void)?

    var body: some View {
        VStack {
            data.isEmpty ? AnyView(emptyView) : AnyView(contentView)
            
            Spacer()
            
            Button(action: {
                buttonAction?()
                navigateToAdd.wrappedValue.toggle()
            }) {
                AddButton(
                    text: buttonText,
                    image: buttonImage,
                    buttonColor: buttonColor,
                    textColor: textColor,
                    width: 300,
                    height: 50
                )
                .padding()
            }
            .navigationDestination(isPresented: navigateToAdd) {
                destinationView
            }
        }
    }
}

struct ReusableListStateView_Previews: PreviewProvider {
    struct SampleData: Identifiable {
        let id = UUID()
        let title: String
    }

    static var sampleEmptyView: some View {
        VStack {
            Text("No Items")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }

    static var sampleContentView: some View {
        List {
            ForEach(0..<5) { index in
                Text("Item \(index + 1)")
                    .padding()
                    .background(Color.antiqueWhite)
                    .cornerRadius(10)
                    .listRowBackground(Color.antiqueWhite)
            }
        }
        .scrollDisabled(true)
    }

    static var previews: some View {
        ReusableListStateView(
            data: [SampleData(title: "Sample 1"), SampleData(title: "Sample 2")],
            emptyView: sampleEmptyView,
            contentView: sampleContentView,
            buttonText: "Add Item",
            buttonImage: Image(systemName: "plus.circle.fill"),
            buttonColor: .blue,
            textColor: .white,
            destinationView: Text("Destination View"),
            navigateToAdd: .constant(false),
            buttonAction: nil
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
