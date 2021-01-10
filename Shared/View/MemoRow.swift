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
        VStack(alignment: .leading, spacing: 0.0) {
            Text(memo.created_at)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal, 5)
                .padding(.top, 10)
                .padding(.horizontal, 10)
            RichText(message: $memo.content)
                .padding(.horizontal, 10)
        }
        .background(Color.white)
        .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
//        .background(
//            ZStack {
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(UIColor.red, style: StrokeStyle(lineWidth: 4))
//
//
//            }
//        )
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .clipped()
        .shadow(radius: 2 )
        
    }
    
    func getText(html: String) -> String {
        let doc = try? SwiftSoup.parse(html)
        return try! doc!.text()
    }
}

struct memoLine_Previews: PreviewProvider {
    static var previews: some View {
        MemoRow(memo: APIMemos()!.sample(id: 0))
    }
}
