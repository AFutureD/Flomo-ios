//
//  memoLine.swift
//  flomo
//
//  Created by AFuture on 2021/1/8.
//

import SwiftUI
import WebKit
import SwiftSoup


struct MemoRow: View {
    @State var memo: Memo
    
    var body: some View {
        VStack(alignment: .leading, spacing:0.0) {
            Text(memo.created_at)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 15)
                .padding(.horizontal, 15)
                .padding(.bottom, 5)
                .lineLimit(0)
//            RichText(message: $memo.content)
//                .padding(.horizontal, 10)
//            GeometryReader { geo in
            htmlRender(message: memo.content)
                    .frame(minWidth: 0, maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
                    
//            }
//            TextEditor(text: $memo.content)
            
        }
        .background(Color.white)
        .cornerRadius(15)
//        .padding(.horizontal, 8)
//        .padding(.vertical, 10)
//        .shadow(radius: 2 )
        
        
    }
    
    func getText(html: String) -> String {
        let doc = try? SwiftSoup.parse(html)
        return try! doc!.text()
    }
}

struct memoLine_Previews: PreviewProvider {
    static var previews: some View {
        MemoRow(memo: APIMemos()!.sample(id: 1))
    }
}
