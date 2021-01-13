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
        
        if ele.nodeName() == "#text" {
//            AnyView(Text(try! ele.outerHtml()))
            return AnyView(Text(try! ele.outerHtml()))
        }
        else {
            if ele.nodeName() == "u"{
//                let subView = postOrder(ele.childNode(0), level + 1)
//                var mirror = Mirror(reflecting: subView)
//                for child in mirror.children {
//                    print("label: \(child.label)")
//                    print("value: \(child.value)")
//                }
//                print(subView)
//                if let u = mirror.children.first!.value as? SwiftUI.AnyViewStorage<SwiftUI.Text>{
//                    return AnyView(Text("1"))
//                }
//                else {return AnyView(Text(""))}
                return AnyView(Text(try! ele.childNode(0).outerHtml()).underline())
//            } else if ele.nodeName() == "p"{
//                let childrens = ele.getChildNodes()
//                let subViews = childrens.map { node in
//                    postOrder(node, level + 1)
//                }
//                return subViews.reduce(Text(""),+)
            } else {
                let childrens = ele.getChildNodes()

                return AnyView(VStack(alignment: .leading){
                    ForEach(0..<childrens.count){ i in
                        postOrder(childrens[i], level + 1)
                    }
                })
            }
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
