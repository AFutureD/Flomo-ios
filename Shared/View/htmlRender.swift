//
//  htmlRender.swift
//  flomo
//
//  Created by AFuture on 2021/1/12.
//

import SwiftUI
import SwiftSoup

struct htmlRender: View {
    var message: String
    
    var body: some View {
        let doc: Document = try! SwiftSoup.parseBodyFragment(message)
        let body: Element = doc.body()!
        return postOrder(body, 1)
//        soup(body, 1)
//        return Text("")
    }
    

    func postOrder(_ ele: Node, _ level: Int) -> AnyView {
        
//        if ele.nodeName() == "#text" {
//            return AnyView(Text(try! ele.outerHtml()))
//        }
//        else {
//            if ele.nodeName() == "u"{
//                return AnyView(Text(try! ele.childNode(0).outerHtml()).underline())
//            } else if ele.nodeName() == "p" {
//                print(try! ele.outerHtml())
//                let childrens = ele.getChildNodes()
//                let subViews = childrens.map { node -> Text in
//                    let subView = postOrder(node, level + 1)
//                    let m = Mirror(reflecting: subView)
//                    let mm = Mirror(reflecting: m.children.first!.value)
//                    if let u = mm.children.first!.value as? Text {
//                        return u
//                    } else { return Text("")}
//                }
//                return AnyView(subViews.reduce(Text(""),+))
//            } else if ele.nodeName() == "strong" {
//                return AnyView(Text(try! ele.childNode(0).outerHtml()).bold())
//            } else {
//                let childrens = ele.getChildNodes()
//
//                return AnyView(VStack(alignment: .leading){
//                    ForEach(0..<childrens.count){ i in
//                        postOrder(childrens[i], level + 1)
//                    }
//                })
//            }
//        }
        
        switch ele.nodeName() {
        case "#text":
            let content = try! ele.outerHtml()
            let texts = content.parseRichTextElements(regex: "(?<=^|[:space:])#[[:graph:]]+")
            print(texts)
            var textsMap = texts.map { (t,flag) -> Text in
                if flag {
                    return Text(t)
                        .foregroundColor(
                            Color(UIColor(
                                red: 88/255.0, green: 131/255.0, blue: 247/255.0,
                                alpha: 1.000)))
                } else {
                    return Text(t)
                }
            }
            return AnyView(textsMap.reduce(Text(""),+))
//            return AnyView(Text(content))
        case "u":
            return AnyView(Text(try! ele.childNode(0).outerHtml()).underline())
        case "strong":
            return AnyView(Text(try! ele.childNode(0).outerHtml()).bold())
        case "p":
//            print(try! ele.outerHtml())
            let childrens = ele.getChildNodes()
            let subViews = childrens.map { node -> Text in
                let subView = postOrder(node, level + 1)
                let m = Mirror(reflecting: subView)
                let mm = Mirror(reflecting: m.children.first!.value)
                if let u = mm.children.first!.value as? Text {
                    return u
                } else { return Text("")}
            }
            return AnyView(subViews.reduce(Text(""),+))
        case "ul":
//            print("========")
//            print(try! ele.outerHtml())
            let childrens = ele.getChildNodes()

            return AnyView(VStack(alignment: .leading){
                ForEach(0..<childrens.count){ i in
                    HStack(alignment: .top){
                        Text(" - ")
                        postOrder(childrens[i], level + 1)
                    }
                }
            })
//
        case "ol":
            let childrens = ele.getChildNodes()
            return AnyView(VStack(alignment: .leading){
                ForEach(0..<childrens.count){ i in
                    HStack(alignment: .top){
                        Text(" \(i + 1). ")
                        postOrder(childrens[i], level + 1)
                    }
                }
            })
        case "li":
//            print("========")
//            print(try! ele.outerHtml())
            let childrens = ele.getChildNodes()
            let subViews = childrens.enumerated().map { (index, node) -> AnyView in
                let subView = postOrder(node, level + 1)
                let m = Mirror(reflecting: subView)
                let mm = Mirror(reflecting: m.children.first!.value)
                if let u = mm.children.first!.value as? Text {
                    return AnyView(u)
                } else { return subView}
            }
            return AnyView(VStack(alignment: .leading){
                ForEach(0..<subViews.count){ i in
                    subViews[i]
                }
            })
        default:
            let childrens = ele.getChildNodes()

            return AnyView(VStack(alignment: .leading){
                ForEach(0..<childrens.count){ i in
                    postOrder(childrens[i], level + 1)
                }
            })
        }
        
    }
    
    func soup(_ ele: Node, _ level: Int){
        print("==== \(level) \(ele.nodeName()) ====")
        print(try! ele.outerHtml())
        let childrens = ele.getChildNodes()
        for node in childrens {
            soup(node , level + 1)
        }
        
    }
}

extension String {
    
    func parseRichTextElements(regex: String) -> [(String,Bool)] {
        let regex = try! NSRegularExpression(pattern: regex)
        let range = NSRange(location: 0, length: count)
        
        /// Find all the ranges that match the regex *CONTENT*.
        let matches: [NSTextCheckingResult] = regex.matches(in: self, options: [], range: range)
        let matchingRanges = matches.compactMap { Range<Int>($0.range) }
        var elements: [(String,Bool)] = []
        
        let firstRange = 0..<(matchingRanges.count == 0 ? count : matchingRanges[0].lowerBound)
        
        if !self[firstRange].isEmpty {
            elements.append((self[firstRange],false))
        }
        
        
        for (index, matchingRange) in matchingRanges.enumerated() {
            let isLast = matchingRange == matchingRanges.last
            
            let matchContent = self[matchingRange]

            elements.append((matchContent,true))
            
            let endLocation = isLast ? count : matchingRanges[index + 1].lowerBound
            let range = matchingRange.upperBound..<endLocation

            if !self[range].isEmpty {
                elements.append((self[range],false))
            }
        }
        
        return elements
    }
    
    /// - Returns: A string subscript based on the given range.
    subscript(range: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = index(self.startIndex, offsetBy: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
}


struct htmlRender_Previews: PreviewProvider {
    static var previews: some View {
        htmlRender(message: APIMemos()!.sample(id: 1).content)
    }
}
