//
//  StoreManager.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 01/06/24.
//


/// - MARK: Add InAppPurchase as capabilities

/*
import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    @Published private(set) var activeTransactions: Set<StoreKit.Transaction> = []
    @Published var products: [Product] = []
    
    init() {
        Task {
            await fetchProducts()
            await fetchActiveTransactions()
        }
    }
    
    func fetchProducts() async {
        do {
            let products = try await Product.products(for: [ProductIdentifiers.monthlySubscription, ProductIdentifiers.yearlySubscription, ProductIdentifiers.oneTimePurchase])
            self.products = products
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }
    
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verificationResult):
            if let transaction = try? verificationResult.payloadValue {
                activeTransactions.insert(transaction)
                await transaction.finish()
            }
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
        } catch {
            print(error)
        }
    }
    
    func fetchActiveTransactions() async {
        var activeTransactions: Set<StoreKit.Transaction> = []
        
        for await entitlement in StoreKit.Transaction.currentEntitlements {
            if let transaction = try? entitlement.payloadValue {
                activeTransactions.insert(transaction)
            }
        }
        
        self.activeTransactions = activeTransactions
    }
}
*/
