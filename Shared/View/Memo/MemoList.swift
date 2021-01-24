//
//  MemoList.swift
//  flomo
//
//  Created by AFuture on 2021/1/10.
//

import SwiftUI

struct MemoList: View {
    @EnvironmentObject var store: Store
    
    var memoList: [Memo] { store.appState.memoList.allMemosByTime }
    
    var body: some View {
//        ScrollView {
//            VStack(spacing: 10) {
//                ForEach(memoList.allMemosByTime) { memo in
//                    MemoRow(memo:memo)
//                        .padding(.horizontal, 10.0)
//                }
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .background(Color(UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.000)))
//        .edgesIgnoringSafeArea(.bottom)
        
        VStack() {
            List(0..<memoList.count){ i in
//                ForEach(memoList.allMemosByTime) { memo in
                    MemoRow(memo:memoList[i])
//                        .padding(.horizontal, 10.0)
//                }
            }
            .listStyle(PlainListStyle())
            
//            .listStyle(GroupedListStyle())
//            .navigationBarHidden(true)
        }
        .frame(maxWidth: .infinity)
//        .background(Color(UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.000)))
//        .edgesIgnoringSafeArea(.all)
        
    }
}

struct MemoList_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.memoList.memos = Dictionary(
            uniqueKeysWithValues: APIMemos.getMemos().memos.map { ($0.id, $0) }
        )
        return MemoList().environmentObject(store)
    }
}
