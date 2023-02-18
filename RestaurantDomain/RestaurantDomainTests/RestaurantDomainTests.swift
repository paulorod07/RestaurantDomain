//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Paulo Rodrigues on 18/02/23.
//

import XCTest
@testable import RestaurantDomain

final class RestaurantDomainTests: XCTestCase {

    func test_initializer_remoteRestaurantLoader_and_validate_url() throws {
        let url = try XCTUnwrap(URL(string: "https://google.com"))
        let networkClient = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: url, networkClient: networkClient)
        
        sut.load()
        
        XCTAssertNotNil(networkClient.url)
        XCTAssertEqual(networkClient.url, url)
    }

}

final class NetworkClientSpy: NetworkClientProtocol {
    
    private(set) var url: URL?
    
    func request(from url: URL) {
        self.url = url
    }
    
}
