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
//                .padding(.top, 15)
                .padding(.horizontal, 5)
//                .padding(.bottom, 0)
                .lineLimit(0)
            
            // Use TextEditor from UIkit to render attribuitedText
            RichText(message: $memo.content)
//                .padding(.horizontal, 10)
//                .frame(minWidth: 0, maxWidth: .infinity,alignment: .leading)
            
            // Use Text from swiftUI to render text.
//            htmlRender(message: memo.content)
//                    .frame(minWidth: 0, maxWidth: .infinity,alignment: .leading)
//                    .padding(.horizontal, 15)
//                    .padding(.bottom, 15)
                    
            
        }
        .background(Color.white)
//        .cornerRadius(15)
//        .padding(.horizontal, 8)
        .padding(.vertical, 10)
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
