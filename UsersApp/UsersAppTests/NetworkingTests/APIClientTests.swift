//
//  APIClientTests.swift
//  UsersAppTests
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import XCTest
import Cuckoo
@testable import UsersApp

final class APIClientTests: XCTestCase {

    var mockTransport: MockNetworkTransportProtocol!
    var mockInterceptors: [MockInterceptorProtocol]!
    var apiClient: APIClient!

    override func setUpWithError() throws {
        mockTransport = MockNetworkTransportProtocol()
        mockInterceptors = [MockInterceptorProtocol()]
        apiClient = APIClient(
            transport: mockTransport,
            interceptors: mockInterceptors
        )
    }

    override func tearDownWithError() throws {
        mockTransport = nil
        mockInterceptors = nil
        apiClient = nil
    }

    // MARK: - Initialization Tests

    func testInitializationWithDefaultParameters() {
        // Given & When
        let client = APIClient(transport: mockTransport)

        // Then
        XCTAssertNotNil(client)
    }

    func testInitializationWithCustomParameters() {
        // Given
        let customDecoder = JSONDecoder()
        let customEncoder = JSONEncoder()

        // When
        let client = APIClient(
            transport: mockTransport,
            interceptors: mockInterceptors,
            jsonDecoder: customDecoder,
            jsonEncoder: customEncoder
        )

        // Then
        XCTAssertNotNil(client)
    }

    // MARK: - Request Building Tests

    func testBuildURLRequestWithValidEndpoint() throws {
        // Given
        let endpoint = UserEndpoint.userList(page: "1", results: 25)
        let expectedData = createMockUsersDTOData()
        let mockResponse = createMockHTTPResponse(statusCode: 200)

        stub(mockTransport) { mock in
            when(mock.performRequest(any())).thenReturn((expectedData, mockResponse))
        }

        stub(mockInterceptors[0]) { mock in
            when(mock.intercept(request: any())).thenReturn(any())
            when(mock.intercept(data: any(), response: any(), for: any())).thenReturn(expectedData)
        }

        // When
        let _: UsersDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UsersDTO.self
        )

        // Then
        verify(mockTransport).performRequest(any())
    }

    func testBuildURLRequestWithQueryParameters() async throws {
        // Given
        let endpoint = UserEndpoint.userList(page: "2", results: 50)
        let expectedData = createMockUsersDTOData()
        let mockResponse = createMockHTTPResponse(statusCode: 200)

        stub(mockTransport) { mock in
            when(mock.performRequest(any())).thenReturn((expectedData, mockResponse))
        }

        stub(mockInterceptors[0]) { mock in
            when(mock.intercept(request: any())).thenReturn(any())
            when(mock.intercept(data: any(), response: any(), for: any())).thenReturn(expectedData)
        }

        // When
        let _: UsersDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UsersDTO.self
        )

        // Then
        verify(mockTransport).performRequest(any())
    }

    // MARK: - Interceptor Tests

    func testRequestInterceptorsCalled() async throws {
        // Given
        let endpoint = UserEndpoint.userList(page: "1", results: 25)
        let expectedData = createMockUsersDTOData()
        let mockResponse = createMockHTTPResponse(statusCode: 200)
        let mockRequest = createMockURLRequest()

        stub(mockTransport) { mock in
            when(mock.performRequest(any())).thenReturn((expectedData, mockResponse))
        }

        stub(mockInterceptors[0]) { mock in
            when(mock.intercept(request: any())).thenReturn(mockRequest)
            when(mock.intercept(data: any(), response: any(), for: any())).thenReturn(expectedData)
        }

        // When
        let _: UsersDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UsersDTO.self
        )

        // Then
        verify(mockInterceptors[0]).intercept(request: any())
        verify(mockInterceptors[0]).intercept(data: any(), response: any(), for: any())
    }

    func testMultipleInterceptorsCalled() async throws {
        // Given
        let secondInterceptor = MockInterceptorProtocol()
        let interceptors = [mockInterceptors[0], secondInterceptor]
        let apiClient = APIClient(
            transport: mockTransport,
            interceptors: interceptors
        )

        let endpoint = UserEndpoint.userList(page: "1", results: 25)
        let expectedData = createMockUsersDTOData()
        let mockResponse = createMockHTTPResponse(statusCode: 200)
        let mockRequest = createMockURLRequest()

        stub(mockTransport) { mock in
            when(mock.performRequest(any())).thenReturn((expectedData, mockResponse))
        }

        stub(mockInterceptors[0]) { mock in
            when(mock.intercept(request: any())).thenReturn(mockRequest)
            when(mock.intercept(data: any(), response: any(), for: any())).thenReturn(expectedData)
        }

        stub(secondInterceptor) { mock in
            when(mock.intercept(request: any())).thenReturn(mockRequest)
            when(mock.intercept(data: any(), response: any(), for: any())).thenReturn(expectedData)
        }

        // When
        let _: UsersDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UsersDTO.self
        )

        // Then
        verify(mockInterceptors[0]).intercept(request: any())
        verify(mockInterceptors[0]).intercept(data: any(), response: any(), for: any())
        verify(secondInterceptor).intercept(request: any())
        verify(secondInterceptor).intercept(data: any(), response: any(), for: any())
    }

    // MARK: - Response Validation Tests

    func testValidateResponseSuccess() async throws {
        // Given
        let endpoint = UserEndpoint.userList(page: "1", results: 25)
        let expectedData = createMockUsersDTOData()
        let mockResponse = createMockHTTPResponse(statusCode: 200)

        stub(mockTransport) { mock in
            when(mock.performRequest(any())).thenReturn((expectedData, mockResponse))
        }

        stub(mockInterceptors[0]) { mock in
            when(mock.intercept(request: any())).thenReturn(any())
            when(mock.intercept(data: any(), response: any(), for: any())).thenReturn(expectedData)
        }

        // When
        let result: UsersDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UsersDTO.self
        )

        // Then
        XCTAssertEqual(result.results.count, 2)
    }

    func testValidateResponseWithDifferentStatusCodes() async throws {
        let statusCodes = [201, 204, 299]

        for statusCode in statusCodes {
            // Given
            let endpoint = UserEndpoint.userList(page: "1", results: 25)
            let expectedData = createMockUsersDTOData()
            let mockResponse = createMockHTTPResponse(statusCode: statusCode)

            stub(mockTransport) { mock in
                when(mock.performRequest(any())).thenReturn((expectedData, mockResponse))
            }

            stub(mockInterceptors[0]) { mock in
                when(mock.intercept(request: any())).thenReturn(any())
                when(mock.intercept(data: any(), response: any(), for: any())).thenReturn(expectedData)
            }

            // When
            let result: UsersDTO = try await apiClient.request(
                endpoint: endpoint,
                responseType: UsersDTO.self
            )

            // Then
            XCTAssertEqual(result.results.count, 2)
        }
    }

    // MARK: - JSON Decoding Tests

    func testJSONDecodingWithSnakeCase() async throws {
        // Given
        let endpoint = UserEndpoint.userList(page: "1", results: 25)
        let snakeCaseData = createSnakeCaseJSONData()
        let mockResponse = createMockHTTPResponse(statusCode: 200)

        stub(mockTransport) { mock in
            when(mock.performRequest(any())).thenReturn((snakeCaseData, mockResponse))
        }

        stub(mockInterceptors[0]) { mock in
            when(mock.intercept(request: any())).thenReturn(any())
            when(mock.intercept(data: any(), response: any(), for: any())).thenReturn(snakeCaseData)
        }

        // When
        let result: UsersDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UsersDTO.self
        )

        // Then
        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results[0].gender, "male")
    }

    func testJSONDecodingWithISO8601Date() async throws {
        // Given
        let endpoint = UserEndpoint.userList(page: "1", results: 25)
        let iso8601Data = createISO8601DateJSONData()
        let mockResponse = createMockHTTPResponse(statusCode: 200)

        stub(mockTransport) { mock in
            when(mock.performRequest(any())).thenReturn((iso8601Data, mockResponse))
        }

        stub(mockInterceptors[0]) { mock in
            when(mock.intercept(request: any())).thenReturn(any())
            when(mock.intercept(data: any(), response: any(), for: any())).thenReturn(iso8601Data)
        }

        // When
        let result: UsersDTO = try await apiClient.request(
            endpoint: endpoint,
            responseType: UsersDTO.self
        )

        // Then
        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results[0].gender, "male")
    }

    // MARK: - Error Handling Tests

    func testTransportError() async throws {
        // Given
        let endpoint = UserEndpoint.userList(page: "1", results: 25)
        let transportError = URLError(.notConnectedToInternet)

        stub(mockTransport) { mock in
            when(mock.performRequest(any())).thenThrow(transportError)
        }

        // When & Then
        do {
            let _: UsersDTO = try await apiClient.request(
                endpoint: endpoint,
                responseType: UsersDTO.self
            )
            XCTFail("Expected transport error")
        } catch {
            // Expected error
        }
    }

    func testInterceptorError() async throws {
        // Given
        let endpoint = UserEndpoint.userList(page: "1", results: 25)
        let interceptorError = NetworkError.unauthorized

        stub(mockInterceptors[0]) { mock in
            when(mock.intercept(request: any())).thenThrow(interceptorError)
        }

        // When & Then
        do {
            let _: UsersDTO = try await apiClient.request(
                endpoint: endpoint,
                responseType: UsersDTO.self
            )
            XCTFail("Expected interceptor error")
        } catch {
            // Expected error
        }
    }

    // MARK: - Helper Methods

    private func createMockUsersDTOData() -> Data {
        let usersDTO = UsersDTO(
            results: [
                UserDTO(
                    gender: "male",
                    name: NameDTO(title: "Mr", first: "John", last: "Doe"),
                    dateOfBirth: DateOfBirthDTO(date: "1990-01-01", age: 33),
                    phone: "+1234567890",
                    picture: PictureDTO(large: "large.jpg", medium: "medium.jpg", thumbnail: "thumb.jpg"),
                    nationality: "US"
                ),
                UserDTO(
                    gender: "female",
                    name: NameDTO(title: "Ms", first: "Jane", last: "Smith"),
                    dateOfBirth: DateOfBirthDTO(date: "1992-05-15", age: 31),
                    phone: "+0987654321",
                    picture: PictureDTO(large: "large2.jpg", medium: "medium2.jpg", thumbnail: "thumb2.jpg"),
                    nationality: "CA"
                )
            ],
            info: InfoDTO(seed: "test", results: 2, page: 1, version: "1.0")
        )

        do {
            return try JSONEncoder().encode(usersDTO)
        } catch {
            XCTFail("Failed to encode UsersDTO: \(error)")
            return Data()
        }
    }

    private func createSnakeCaseJSONData() -> Data {
        let jsonString = """
        {
            "results": [
                {
                    "gender": "male",
                    "name": {
                        "title": "Mr",
                        "first": "John",
                        "last": "Doe"
                    },
                    "dob": {
                        "date": "1990-01-01",
                        "age": 33
                    },
                    "phone": "+1234567890",
                    "picture": {
                        "large": "large.jpg",
                        "medium": "medium.jpg",
                        "thumbnail": "thumb.jpg"
                    },
                    "nat": "US"
                }
            ],
            "info": {
                "seed": "test",
                "results": 1,
                "page": 1,
                "info_version": "1.0"
            }
        }
        """
        return jsonString.data(using: .utf8)!
    }

    private func createISO8601DateJSONData() -> Data {
        let jsonString = """
        {
            "results": [
                {
                    "gender": "male",
                    "name": {
                        "title": "Mr",
                        "first": "John",
                        "last": "Doe"
                    },
                    "dob": {
                        "date": "1990-01-01T00:00:00Z",
                        "age": 33
                    },
                    "phone": "+1234567890",
                    "picture": {
                        "large": "large.jpg",
                        "medium": "medium.jpg",
                        "thumbnail": "thumb.jpg"
                    },
                    "nat": "US"
                }
            ],
            "info": {
                "seed": "test",
                "results": 1,
                "page": 1,
                "info_version": "1.0"
            }
        }
        """
        return jsonString.data(using: .utf8)!
    }

    private func createMockHTTPResponse(statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    private func createMockURLRequest() -> URLRequest {
        return URLRequest(url: URL(string: "https://test.com")!)
    }
}
