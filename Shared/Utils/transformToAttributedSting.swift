//
//  transformToAttributedSting.swift
//  flomo
//
//  Created by AFuture on 2021/1/10.
//

import Foundation
import SwiftUI
import Atributika

func transformToAttributedSting(content: String) -> NSAttributedString{
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
            let unorderListPrefix = " ◦  "
            let numberListPrefix  = " \(counter). "

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
    paragraphStyle.headIndent = 14
    
    let li = Style("li")
            .paragraphStyle(paragraphStyle)
    
    let u = Style("u")
        .underlineStyle(.single)
    
    let strongStyle = Style("strong")
        .font(UIFont(name: "Helvetica-Bold", size: 14)!)
    
    let all = Style
        .font(UIFont(name: "Helvetica", size: 14)!)
    
    return content
        .style(tags: [li,u,strongStyle], transformers: transformers)
        .style(regex: "#\\S+", style: hashTag)
        .styleAll(all)
        .attributedString
}
