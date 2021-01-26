//
//  MainTab.swift
//  flomo
//
//  Created by AFuture on 2021/1/15.
//

import SwiftUI

struct MainTab: View {
    var body: some View {
        TabView {
            MemoRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("Memo")
            }
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.memoList.memos = Dictionary(
            uniqueKeysWithValues: APIMemos.getMemos().memos.map { ($0.id, $0) }
        )
        return MainTab().environmentObject(store)
    }
}
