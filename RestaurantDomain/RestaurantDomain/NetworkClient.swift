//
//  NetworkClient.swift
//  RestaurantDomain
//
//  Created by Paulo Rodrigues on 20/02/23.
//

import Foundation

public protocol NetworkClient {
    typealias NetworkResult = Result<(Data, HTTPURLResponse), Error>
    func request(from url: URL) async -> NetworkResult
}

final class NetworkService: NetworkClient {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(from url: URL) async -> NetworkResult {
        let urlRequest = URLRequest(url: url)
        
        session.dataTask(with: urlRequest) { _, _, _ in
            
        }
        
        return .success((Data(), .init()))
    }
    
}
