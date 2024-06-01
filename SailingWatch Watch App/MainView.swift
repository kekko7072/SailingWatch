//
//  MainView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 01/06/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var storeManager: StoreManager
    @State var dismissPurchase: Bool
    
    init(storeManager: StoreManager,_ dismissPurchase: Bool = false) {
        self.storeManager = storeManager
        self.dismissPurchase = !storeManager.activeTransactions.isEmpty
    }
    
    var body: some View {
        TabView {
            TimerView()
            if !storeManager.activeTransactions.isEmpty {
                StartView()
            } else {
                StoreView(storeManager: storeManager)
            }
        }
        .tabViewStyle(PageTabViewStyle()).sheet(isPresented: $dismissPurchase) {
            StoreView(storeManager: storeManager, dismissPurchase)
        }
    }
}

#Preview {
    MainView(storeManager: StoreManager())
}
