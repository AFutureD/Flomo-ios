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
        
        switch ele.nodeName() {
        case "#text":
            let content = try! ele.outerHtml()
            let texts = content.parseRichTextElements(regex: "(?<=^|[:space:])#[[:graph:]]+")
            let textsMap = texts.map { (t,flag) -> Text in
                if flag {
                    return Text(t)
                        .font(.system(size: 15))
                        .foregroundColor(
                            Color(UIColor(
                                red: 88/255.0, green: 131/255.0, blue: 247/255.0,
                                alpha: 1.000)))
                } else {
                    return Text(t).font(.system(size: 15))
                }
            }
            return AnyView(textsMap.reduce(Text("").font(.system(size: 15)),+))
        case "u":
            return AnyView(Text(try! ele.childNode(0).outerHtml()).font(.system(size: 15)).underline())
        case "strong":
            return AnyView(Text(try! ele.childNode(0).outerHtml()).font(.system(size: 15)).bold())
        case "p":
//            print(try! ele.outerHtml())
            let childrens = ele.getChildNodes()
            let subViews = childrens.map { node -> Text in
                let subView = postOrder(node, level + 1)
                let m = Mirror(reflecting: subView)
                let mm = Mirror(reflecting: m.children.first!.value)
                if let u = mm.children.first!.value as? Text {
                    return u
                } else { return Text("").font(.system(size: 15))}
            }
            return AnyView(subViews.reduce(Text("").font(.system(size: 15)),+))
        case "ul":
//            print("========")
//            print(try! ele.outerHtml())
            let childrens = ele.getChildNodes()
            if childrens.count == 1{
                return AnyView(
                    HStack(alignment: .top){
                    Text(" - ").font(.system(size: 15))
                    postOrder(childrens[0], level + 1)
                })
            } else {
                return AnyView(VStack(alignment: .leading){
                    ForEach(0..<childrens.count, id: \.self){ i in
                        HStack(alignment: .top){
                            Text(" - ").font(.system(size: 15))
                            postOrder(childrens[i], level + 1)
                        }
                    }
                })
            }
//
        case "ol":
            let childrens = ele.getChildNodes()
            return AnyView(VStack(alignment: .leading){
                ForEach(0..<childrens.count, id: \.self){ i in
                    HStack(alignment: .top){
                        Text(" \(i + 1). ").font(.system(size: 15))
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
                ForEach(0..<subViews.count, id: \.self){ i in
                    subViews[i]
                }
            })
        default:
            let childrens = ele.getChildNodes()
//            print("Count: \(childrens.count)")

            return AnyView(VStack(alignment: .leading){
//                print("Count: \(childrens.count)")
                ForEach(0..<childrens.count, id: \.self){ i in
//                    print("index: \(i)")
                    if i < childrens.count {
                        postOrder(childrens[i], level + 1)
                    }
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


struct htmlRender_Previews: PreviewProvider {
    static var previews: some View {
        htmlRender(message: APIMemos()!.sample(id: 1).content)
    }
}
