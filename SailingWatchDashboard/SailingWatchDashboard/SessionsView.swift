//
//  ContentView.swift
//  SailingWatchDashboard
//
//  Created by Francesco Vezzani on 23/06/24.
//

import SwiftUI

struct SessionsView: View {
    @State private var sessions: Int = 0
    @State private var locales: [String: Int] = [:]
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("Today").font(.title2)
                HStack{
                    Spacer()
                    Text("Countries: \(locales.count)")
                    Spacer()
                    Text("Sessions: \(sessions)")
                    Spacer()
                }
                .font(.headline)
                ChartView(forLocales: locales, chartType: .pie)
            }
        }
        .padding()
        .navigationTitle("Sessions")
        .onAppear {
            fetchData()
        }
    }
    
    private func fetchData() {
        NetworkManager.shared.fetchDAUData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.sessions = data.sessions
                    self.locales = data.locales
                case .failure(let error):
                    self.errorMessage = "Error fetching data: \(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    SessionsView()
}
