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

final class RemoteRestaurantLoader {
    
    let url: URL
    let networkClient: NetworkClient
    private let okResponse: Int = 200
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(url: URL, networkClient: NetworkClient) {
        self.url = url
        self.networkClient = networkClient
    }
    
    typealias RemoteRestaurantResult = Result<[RestaurantItem], RemoteRestaurantLoader.Error>
    func load() async -> RemoteRestaurantResult {
        let result = await networkClient.request(from: url)
        
        switch result {
            case let .success((data, response)):
                
                guard
                    let json = try? JSONDecoder().decode(RestaurantRoot.self, from: data),
                    response.statusCode == okResponse
                else { return .failure(.invalidData) }
                
                return .success(json.items)
                
            case .failure:
                return .failure(.connectivity)
        }
    }
    
}
