//
//  RichText.swift
//  flomo
//
//  Created by AFuture on 2021/1/9.
//

import SwiftUI
import Atributika
import Foundation


struct RichText: View {

    @Binding var message: String
    @State var desirHeight: CGFloat = 0.0
    
    var body: some View {
        TextView(
            text: $message,
            attributedText: .constant(nil)
        )
    }
}


struct TextView: UIViewRepresentable {

    @Binding var text: String
    @Binding var attributedText: NSAttributedString?

    func makeUIView(context: Context) -> UILabel {

        let label = UILabel()
        label.attributedText = self.transformToAttributedSting(content: self.text)
//        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
    }
    
    func transformToAttributedSting(content: String) -> NSAttributedString{
//        print("In Render")
        print(content)
        var counter = 0
        var indent = 0
        var inli = 0
        var listType = -1 // -1: not list; 1: number list; 0: Unorder list
        var pcounter = 0 // count the number of p tag in list
        let transformers: [Atributika.TagTransformer] = [
            TagTransformer.brTransformer,
            TagTransformer(tagName: "ol", tagType: .start) { _ in
                counter = 0
                indent += 1
                listType = 1
                return ""
            },
            TagTransformer(tagName: "ol", tagType: .end) { _ in
                counter = 0
                indent -= 1
                if indent == 0 {listType = -1}
                return ""
            },
            
            TagTransformer(tagName: "ul", tagType: .start) { _ in
                indent += 1
                listType = 0
                return ""
            },
            TagTransformer(tagName: "ul", tagType: .end) { _ in
                indent -= 1
                if indent == 0 {listType = -1}
                return ""
            },
            
            TagTransformer(tagName: "li", tagType: .start) { _ in
                counter += 1
                inli += 1
                pcounter = 0
                let unorderListPrefix = "-  "
                let numberListPrefix  = "\(counter). "

                return "\(String(repeating: "    ", count: indent-1))\(listType == 1 ? numberListPrefix : unorderListPrefix)"
            },
            TagTransformer(tagName: "li", tagType: .end) { _ in
                inli -= 1

                return ""
            },
            
            TagTransformer(tagName: "p", tagType: .end, replaceValue: "\n"),
            TagTransformer(tagName: "p", tagType: .start) { _ in
                pcounter += 1
                if inli > 0 && pcounter > 1{
                    return "\(String(repeating: "    ", count: indent))"
                } else { return "" }
            }
        ]
        
        let hashTag = Style("")
            .foregroundColor(
                UIColor(red: 88/255.0, green: 131/255.0, blue: 247/255.0, alpha: 1.000)
            )
            .backgroundColor(
                UIColor(red: 238/255.0, green: 243/255.0, blue: 254/255.0, alpha: 1.000)
            )

        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
//        paragraphStyle.lineSpacing = -0.5
        
        let li = Style("li")
                .paragraphStyle(paragraphStyle)
        
        let u = Style("u")
            .underlineStyle(.single)
        
        let strongStyle = Style("strong")
            .font(UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.heavy))
        
        let all = Style
            .font(UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium))
        
        return content
            .style(tags: [li,u,strongStyle], transformers: transformers)
            .style(regex: "(?<=^|[:space:])#[[:graph:]]+", style: hashTag)
//            .style(regex: "(?<=^|\s)#[\S\/]+", style: hashTag)
            .styleAll(all)
            .attributedString
    }
}

//let textView = UITextView()
//var attributedText: NSAttributedString = transformToAttributedSting(content: text)
//textView.attributedText = attributedText
//
//textView.isEditable = false
//textView.isScrollEnabled = false

struct RichText_Previews: PreviewProvider {
    
    @State static var message:String = APIMemos()!.sample(id: 1).content
    static var previews: some View {
        RichText(message: $message)
    }
}
