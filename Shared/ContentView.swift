//
//  ContentView.swift
//  Shared
//
//  Created by AFuture on 2021/1/8.
//

import SwiftUI

struct ContentView: View {
        
    var body: some View {
//        MemoList()
//        htmlRender(message: APIMemos()!.sample(id: 1).content)
        let store = Store()
        SettingRootView().environmentObject(store)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
