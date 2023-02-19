//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Paulo Rodrigues on 18/02/23.
//

import Foundation

struct RestaurantRoot: Decodable {
    let items: [RestaurantItem]
}

struct RestaurantItem: Decodable, Equatable {
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
    
    typealias RemoteRestaurantResult = Result<[RestaurantItem], RemoteRestaurantLoader.Error>
    func load() async -> RemoteRestaurantResult {
        let result = await networkClient.request(from: url)
        
        switch result {
            case let .success((data, _)):
                
                guard
                    let json = try? JSONDecoder().decode(RestaurantRoot.self, from: data)
                else { return .failure(.invalidData) }
                
                return .success(json.items)
                
            case .failure:
                return .failure(.connectivity)
        }
    }
    
}
