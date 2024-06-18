//
//  StoreView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 01/06/24.
//


/// - MARK: Add InAppPurchase as capabilities

/*
import SwiftUI
import StoreKit

struct StoreView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var storeManager: StoreManager
    @State var dismissible: Bool
    
    init(storeManager: StoreManager, _ dismissible: Bool = false) {
        self.storeManager = storeManager
        self.dismissible = dismissible
    }
    
    var body: some View {
        ScrollView {
            Text("Line Tracking").bold()
            if storeManager.products.isEmpty {
                ProgressView().padding()
            }else{
                Text("One time purchase").padding(.top, 5)
                ForEach(storeManager.products.filter({ product in
                    product.type == .nonConsumable
                }), id: \.id) { product in
                    Button {
                        Task {
                            try await storeManager.purchase(product)
                            if(dismissible){
                                dismiss()
                            }
                        }
                    } label: {
                        VStack {
                            Text(verbatim: product.displayName)
                                .font(.headline)
                            HStack{
                                Text(verbatim: product.description)
                                Text(verbatim: product.displayPrice)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Text("Subscription purchase").padding(.top, 10)
                ForEach(storeManager.products.filter({ product in
                    product.type == .autoRenewable
                }), id: \.id) { product in
                    Button {
                        Task {
                            try await storeManager.purchase(product)
                            if(dismissible){
                                dismiss()
                            }
                        }
                    } label: {
                        VStack {
                            Text(verbatim: product.displayName)
                                .font(.headline)
                            HStack{
                                Text(verbatim: product.description)
                                Text(verbatim: product.displayPrice)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Button(action: {
                    Task{
                        await storeManager.restorePurchases()
                        if(dismissible){
                            dismiss()
                        }
                    }
                }) {
                    Text("Restore Purchases")
                }
            }
            if(dismissible){
                Button("Dismiss") {
                    dismiss()
                }
            }
        }.navigationBarHidden(true).task {
            await storeManager.fetchProducts()
        }
    }
}

#Preview {
    StoreView(storeManager: StoreManager())
}
*/
