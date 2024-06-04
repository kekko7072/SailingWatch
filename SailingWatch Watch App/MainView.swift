//
//  MainView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 01/06/24.
//

import SwiftUI

struct MainView: View {
    @AppStorage("firstOpeningTimestamp") var firstOpeningTimestamp: Double?
    
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var storeManager: StoreManager
    
    @State private var showAlert = false
    @State private var showStoreSheet = false
    
    var body: some View {
        TabView {
            TimerView()
            ZStack{
                if !showAlert{
                    StartLineDataView(locationManager: locationManager)
                } else {
                    StoreView(storeManager: storeManager)
                }
            }.alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Free Trial"),
                    message: Text("The Line Tracking Feature of the app is free for the first three weeks."),
                    primaryButton: .cancel(Text("Purchase Now"), action: {
                        showStoreSheet = true
                    }),
                    secondaryButton: .default(Text("OK"))
                )
            }
            if(locationManager.lineConfigured){
                StartLineMapView(locationManager: locationManager)
            }
        }
        .tabViewStyle(PageTabViewStyle()).onAppear(perform: checkForAlert).sheet(isPresented: $showStoreSheet, content: {
            StoreView(storeManager: storeManager, showStoreSheet)
        })
    }
    
    private func checkForAlert() {
        guard let firstTimestamp = firstOpeningTimestamp else { return }
        
        if(!storeManager.activeTransactions.isEmpty){
            showAlert = false
        }else{
            let firstDate = Date(timeIntervalSince1970: firstTimestamp)
            let currentDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.weekOfYear], from: firstDate, to: currentDate)
            
            if let weeks = components.weekOfYear {
                if weeks >= 1 && weeks < 3 {
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    MainView(locationManager: LocationManager(), storeManager: StoreManager())
}
