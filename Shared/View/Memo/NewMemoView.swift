//
//  sendMemo.swift
//  flomo
//
//  Created by AFuture on 2021/1/26.
//

import Foundation
import SwiftUI

struct NewMemoView : View {
    
    @State private var search: String = ""
    @State private var isValidating: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
//        NavigationView {
//            List {
//                Section {
//                    TextField("Search City", text: $search) {
//
//                    }
//                }
//
//                Section {
//                    ForEach(["df","gg"], id: \.self) { prediction in
//                        Button(action: {
//                            self.presentationMode.wrappedValue.dismiss()
//                        }) {
//                            Text(prediction)
//                                .foregroundColor(.primary)
//                        }
//                    }
//                }
//            }
//                .disabled(isValidating)
//                .navigationBarTitle(Text("Add City"))
//                .navigationBarItems(leading: cancelButton)
//                .listStyle(GroupedListStyle())
//        }
        NavigationView {
            VStack{
                TextEditor(text: $search)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    Image(systemName: "arrow.up.circle.fill")
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.up.circle.fill").resizable()
                    }
                }
            }
            .navigationBarTitle(Text("New Memo"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton)
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "multiply.circle.fill")
        }
    }
    
    private func addCity(from prediction: String) {
//        isValidating = true
//
//        CityValidation.validateCity(withID: prediction.id) { (city) in
//            if let city = city {
//                DispatchQueue.main.async {
//                    self.cityStore.cities.append(city)
//                    self.presentationMode.wrappedValue.dismiss()
//                }
//            }
//
//            DispatchQueue.main.async {
//                self.isValidating = false
//            }
//        }
    }
    
}

struct NewMemoView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.memoList.memos = Dictionary(
            uniqueKeysWithValues: APIMemos.getMemos().memos.map { ($0.id, $0) }
        )
        return NewMemoView().environmentObject(store)
    }
}
