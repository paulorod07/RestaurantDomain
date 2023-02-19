//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Paulo Rodrigues on 18/02/23.
//

import Foundation

struct RestaurantItem {
    let id: UUID
    let name: String
    let location: String
    let distance: Float
    let ratings: Int
    let parasols: Int
}

protocol NetworkClientProtocol {
    typealias NetworkResult = Result<(Data, HTTPURLResponse), Error>
    func request(from url: URL) async -> NetworkResult
}

final class RemoteRestaurantLoader {
    
    let url: URL
    let networkClient: NetworkClientProtocol
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(url: URL, networkClient: NetworkClientProtocol) {
        self.url = url
        self.networkClient = networkClient
    }
    
    func load() async -> RemoteRestaurantLoader.Error {
        let result = await networkClient.request(from: url)
        
        switch result {
            case .success:
                return .invalidData
            case .failure:
                return .connectivity
        }
    }
    
}
