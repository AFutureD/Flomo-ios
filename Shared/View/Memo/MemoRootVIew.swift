//
//  MemoRootVIew.swift
//  flomo
//
//  Created by AFuture on 2021/1/15.
//

import SwiftUI

struct MemoRootVIew: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationView {
            if store.appState.memoList.memos == nil {
                Text("Loading...").onAppear {
                    self.store.dispatch(.loadMemos)
                }
            } else {
                MemoList()
                    .navigationBarTitle("宝可梦列表")
            }
        }
    }
}

struct MemoRootVIew_Previews: PreviewProvider {
    static var previews: some View {
        MemoRootVIew()
    }
}
