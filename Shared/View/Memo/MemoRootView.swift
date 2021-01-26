//
//  MemoRootVIew.swift
//  flomo
//
//  Created by AFuture on 2021/1/15.
//

import SwiftUI

struct MemoRootView: View {
    @EnvironmentObject var store: Store
    @State var isPresentingModal: Bool = false
    
    var body: some View {
        NavigationView {
            if store.appState.memoList.memos == nil {
                Text("Loading...").onAppear {
                    self.store.dispatch(.loadMemos)
                }
            } else {
                MemoList()
                    .navigationTitle("Memo")
                    .navigationBarItems(trailing: addMemoButton)
                    .sheet(isPresented: $isPresentingModal) {
                        NewMemoView()
                    }
            }
        }
    }
    
    var addMemoButton: some View{
        Button(action: {
            // 实现 add memo view. 参考 https://github.com/bpisano/Weather/blob/master/Weather/Views/List/CityListView.swift
            self.isPresentingModal = true
        }) {
            Image(systemName: "square.and.pencil").imageScale(.large)
        }
//        .sheet(isPresented: $isPresentingModal) {
//            NewMemoView()
//        }
    }
}


struct MemoRootView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.memoList.memos = Dictionary(
            uniqueKeysWithValues: APIMemos.getMemos().memos.map { ($0.id, $0) }
        )
        return MemoRootView().environmentObject(store)
    }
}
