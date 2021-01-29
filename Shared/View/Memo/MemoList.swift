//
//  MemoList.swift
//  flomo
//
//  Created by AFuture on 2021/1/10.
//

import SwiftUI
import SwiftUIRefresh

struct MemoList: View {
    @EnvironmentObject var store: Store
//    var isShowing: Bool {
//        store.appState.memoList.loadingMemos
//    }
    @State var isShowing: Bool = false
    
//    @Binding var memoList: [Memo] =  $store.appState.memoList.allMemosByTime
    
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
//            List(0..<memoList.count){ i in
//                    MemoRow(memo:memoList[i])
////                }
//            }
            List(store.appState.memoList.allMemosByTime, id: \.self){ memo in
                MemoRow(memo:memo)
            }
            .listStyle(PlainListStyle())
            .pullToRefresh(isShowing: $isShowing) {
                print(store.appState.memoList.loadingMemos)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.store.dispatch(.loadMemos)
                    self.isShowing = false
                    print("REFRESH")
                }
            }
            .onChange(of: store.appState.memoList.loadingMemos) { value in
            }
            
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
