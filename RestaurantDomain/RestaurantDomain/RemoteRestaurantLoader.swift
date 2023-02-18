//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Paulo Rodrigues on 18/02/23.
//

import Foundation

protocol NetworkClientProtocol {
    func request(from url: URL)
}

final class RemoteRestaurantLoader {
    
    let url: URL
    let networkClient: NetworkClientProtocol
    
    init(url: URL, networkClient: NetworkClientProtocol) {
        self.url = url
        self.networkClient = networkClient
    }
    
    func load() {
        networkClient.request(from: url)
    }
    
}
