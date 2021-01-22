//
//  MemoList.swift
//  flomo
//
//  Created by AFuture on 2021/1/10.
//

import SwiftUI

struct MemoList: View {
    @EnvironmentObject var store: Store
    
    var memoList: AppState.MemoList { store.appState.memoList }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(memoList.allMemosByTime) { memo in
                    MemoRow(memo:memo)
                        .padding(.horizontal, 10.0)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.000)))
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

struct MemoList_Previews: PreviewProvider {
    static var previews: some View {
        MemoList()
    }
}
