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
            attributedText: .constant(nil),
            desiredHeight: $desirHeight
        )
        .frame(height: desirHeight)
        
    }
}


struct TextView: UIViewRepresentable {

    @Binding var text: String
    @Binding var attributedText: NSAttributedString?
    @Binding var desiredHeight: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let uiTextView = UITextView()
        uiTextView.isScrollEnabled = true
        uiTextView.delegate = context.coordinator
        //let textView = UITextView()
//        print(self.text)
//        self.attributedText = self.transformToAttributedSting(content: self.text)
        uiTextView.attributedText = self.transformToAttributedSting(content: self.text)
        uiTextView.isEditable = false
        uiTextView.backgroundColor = .clear
//        uiTextView.isScrollEnabled = false.

        return uiTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
//        if self.attributedText != nil {
//            uiView.attributedText = self.attributedText
//        } else {
//            uiView.text = self.text
//            self.attributedText = transformToAttributedSting(content: self.text)
//            uiView.attributedText = self.attributedText
//        }
        
        uiView.attributedText = self.transformToAttributedSting(content: self.text)

        // Compute the desired height for the content
        let fixedWidth = uiView.frame.size.width
        let newSize = uiView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        DispatchQueue.main.async {
            self.desiredHeight = newSize.height
        }
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ view: TextView) {
            self.parent = view
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
//                self.parent.text = textView.text
                self.parent.attributedText = textView.attributedText
            }
        }
    }
    
    func transformToAttributedSting(content: String) -> NSAttributedString{
        print("In Render")
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
            .style(regex: "^#\\S+", style: hashTag)
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
    
    @State static var message:String = APIMemos()!.sample(id: 0).content
    static var previews: some View {
        RichText(message: $message)
    }
}
