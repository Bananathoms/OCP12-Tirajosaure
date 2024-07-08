//
//  ReusableListView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 01/07/2024.
//

import SwiftUI

struct ReusableListView<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
    let data: Data
    let content: (Data.Element) -> Content
    let onDelete: (IndexSet) -> Void
    let onMove: (IndexSet, Int) -> Void
    let isEditing: Bool

    var body: some View {
        List {
            ForEach(data) { item in
                content(item)
                    .padding(.trailing)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.antiqueWhite)
            }
            .onDelete(perform: onDelete)
            .onMove(perform: onMove)
        }
        .environment(\.editMode, .constant(isEditing ? .active : .inactive))
        .scrollContentBackground(.hidden)
    }
}

struct ReusableListView_Previews: PreviewProvider {
    struct PreviewItem: Identifiable {
        let id = UUID()
        let name: String
    }

    static let sampleData = [
        PreviewItem(name: "Item 1"),
        PreviewItem(name: "Item 2"),
        PreviewItem(name: "Item 3")
    ]

    static var previews: some View {
        ReusableListView(
            data: sampleData,
            content: { item in
                Text(item.name)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            },
            onDelete: { _ in },
            onMove: { _, _ in },
            isEditing: true
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
