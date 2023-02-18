//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Paulo Rodrigues on 18/02/23.
//

import Foundation

final class NetworkClient {
    
    static let shared: NetworkClient = NetworkClient()
    
    private(set) var url: URL?
    
    private init() { }
    
    func request(from url: URL) {
        self.url = url
    }
    
}

final class RemoteRestaurantLoader {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func load() {
        NetworkClient.shared.request(from: url)
    }
    
}
