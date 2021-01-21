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
            MemoList().tabItem {
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
        MainTab()
    }
}
