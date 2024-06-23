//
//  NetworkManager.swift
//  SailingWatchDashboard
//
//  Created by Francesco Vezzani on 23/06/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchDAUData(completion: @escaping (Result<DAUResponse, Error>) -> Void) {
        let urlString = "https://us-central1-sailingwatch-app.cloudfunctions.net/api/dau"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let dauResponse = try JSONDecoder().decode(DAUResponse.self, from: data)
                completion(.success(dauResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
