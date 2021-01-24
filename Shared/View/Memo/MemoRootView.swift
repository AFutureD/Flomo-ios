//
//  MemoRootVIew.swift
//  flomo
//
//  Created by AFuture on 2021/1/15.
//

import SwiftUI

struct MemoRootView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationView {
            if store.appState.memoList.memos == nil {
                Text("Loading...").onAppear {
                    self.store.dispatch(.loadMemos)
                }
            } else {
                MemoList()
                    .navigationTitle("Memo")
//                    .padding(0.001)
//                    .navigationBarHidden(true)
            }
        }
//        .navigationTitle("Memo")
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
