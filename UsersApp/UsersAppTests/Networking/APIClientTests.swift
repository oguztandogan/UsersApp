//
//  APIClientTests.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//


import XCTest
import Cuckoo
@testable import UsersApp

final class APIClientTests: XCTestCase {

    var mockTransport: MockNetworkTransportProtocol!
    var mockInterceptor: MockInterceptorProtocol!
    var sut: APIClient!

    override func setUp() {
        super.setUp()
        mockTransport = MockNetworkTransportProtocol()
        mockInterceptor = MockInterceptorProtocol()
        sut = APIClient(transport: mockTransport, interceptors: [mockInterceptor])
    }

    override func tearDown() {
        mockTransport = nil
        mockInterceptor = nil
        sut = nil
        super.tearDown()
    }
    
    func test_request_success_decodesResponse() async throws {
        // Arrange
        let endpoint = UserEndpoint.userList(page: "1", results: 1)
        let userJson = """
        {
            "results": [{
                "gender": "male",
                "name": {"title": "Mr", "first": "John", "last": "Doe"},
                "dob": {"date": "1990-01-01", "age": 33},
                "phone": "12345",
                "picture": {"large": "l", "medium": "m", "thumbnail": "t"},
                "nat": "US"
            }],
            "info": {"seed": "abc", "results": 1, "page": 1, "info_version": "1"}
        }
        """.data(using: .utf8)!

        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        stub(mockInterceptor) { stub in
            when(stub.intercept(request: any())).then { $0 }
            when(stub.intercept(data: any(), response: any(), for: any())).then { response, _, _ in response }
        }

        stub(mockTransport) { stub in
            when(stub.performRequest(any())).thenReturn((userJson, response))
        }

        // Act
        let result: UsersDTO = try await sut.request(endpoint: endpoint, responseType: UsersDTO.self)

        // Assert
        XCTAssertEqual(result.results.first?.name?.first, "John")
        verify(mockTransport).performRequest(any())
        verify(mockInterceptor).intercept(request: any())
        verify(mockInterceptor).intercept(data: any(), response: any(), for: any())
    }
    
    func test_request_throwsDecodingError() async {
        // Arrange
        let endpoint = UserEndpoint.userList(page: "1")
        let invalidJson = "{ invalid json }".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        stub(mockInterceptor) { stub in
            when(stub.intercept(request: any())).then { $0 }
            when(stub.intercept(data: any(), response: any(), for: any())).then { response, _, _ in response }
        }
        stub(mockTransport) { stub in
            when(stub.performRequest(any())).thenReturn((invalidJson, response))
        }

        // Act & Assert
        do {
            _ = try await sut.request(endpoint: endpoint, responseType: UsersDTO.self)
            XCTFail("Expected decoding error")
        } catch {
            guard case .decodingError = error as? NetworkError else {
                XCTFail("Expected decodingError, got \(error)")
                return
            }
        }
    }
    
    func test_request_throwsUnauthorized() async {
        // Arrange
        let endpoint = UserEndpoint.userList(page: "1")
        let dummyData = Data()
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 401,
                                       httpVersion: nil,
                                       headerFields: nil)!

        stub(mockInterceptor) { stub in
            when(stub.intercept(request: any())).then { $0 }
        }
        stub(mockTransport) { stub in
            when(stub.performRequest(any())).thenReturn((dummyData, response))
        }

        // Act & Assert
        do {
            _ = try await sut.request(endpoint: endpoint, responseType: UsersDTO.self)
            XCTFail("Expected unauthorized error")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }

}
