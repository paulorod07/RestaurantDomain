//
//  NetworkServiceTests.swift
//  RestaurantDomainTests
//
//  Created by Paulo Rodrigues on 20/02/23.
//

import XCTest
@testable import RestaurantDomain

final class NetworkServiceTests: XCTestCase {

    func test_request_and_create_dataTask_with_url() async throws {
        let url = try XCTUnwrap(URL(string: "https://google.com"))
        let session = URLSessionSpy()
        let sut = NetworkService(session: session)
        
        let _ = await sut.request(from: url)
        
        XCTAssertNotNil(session.url)
    }

}

final class URLSessionSpy: URLSession {
    
    private(set) var url: URL?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = request.url
        return URLSessionDataTask()
    }
    
}
