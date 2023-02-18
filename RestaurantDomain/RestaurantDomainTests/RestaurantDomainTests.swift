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
        let sut = RemoteRestaurantLoader(url: url)
        
        sut.load()
        
        XCTAssertNotNil(NetworkClient.shared.url)
    }

}
