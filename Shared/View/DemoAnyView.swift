//
//  DemoAnyView.swift
//  flomo
//
//  Created by AFuture on 2021/1/13.
//

import SwiftUI

struct DemoAnyView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .foregroundColor(
                Color(UIColor(
                        red: 88/255.0, green: 131/255.0, blue: 247/255.0,
                        alpha: 1.000)))
            .padding(5)
//            .background(Color(UIColor(red: 238/255.0, green: 243/255.0, blue: 254/255.0, alpha: 1.000)))
//        + Text("tt")
    }
}


struct DemoAnyView_Previews: PreviewProvider {
    static var previews: some View {
        DemoAnyView()
    }
}
