//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Paulo Rodrigues on 18/02/23.
//

import Foundation

enum NetworkState {
    case success
    case error(Error)
}

protocol NetworkClientProtocol {
    func request(from url: URL) async -> NetworkState
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
        let state = await networkClient.request(from: url)
        
        switch state {
            case .success:
                return .invalidData
            case .error:
                return .connectivity
        }
    }
    
}
