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
//        MemoRow(memo: APIMemos()!.sample(id: 1))
        MemoEditorView()
        // DONE: show mainTab in app, and transfer PokeMaster's example to this project.
//        let store = Store()
//        MainTab().environmentObject(store)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
