//
//  MemoList.swift
//  flomo
//
//  Created by AFuture on 2021/1/10.
//

import SwiftUI

struct MemoList: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(APIMemos.getMemos()) { memo in
                    MemoRow(memo:memo)
                }
            }
        }
        .background(Color(UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.000)))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct MemoList_Previews: PreviewProvider {
    static var previews: some View {
        MemoList()
    }
}
