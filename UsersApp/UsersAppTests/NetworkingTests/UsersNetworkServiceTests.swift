//
//  UsersNetworkServiceTests.swift
//  UsersAppTests
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import XCTest
import Cuckoo
@testable import UsersApp

final class UsersNetworkServiceTests: XCTestCase {

    var mockAPIClient: MockNetworkClientProtocol!
    var mockMapper: MockUserMapperProtocol!
    var usersNetworkService: UsersNetworkService!

    override func setUpWithError() throws {
        mockAPIClient = MockNetworkClientProtocol()
        mockMapper = MockUserMapperProtocol()
        usersNetworkService = UsersNetworkService(
            apiClient: mockAPIClient,
            mapper: mockMapper
        )
    }

    override func tearDownWithError() throws {
        mockAPIClient = nil
        mockMapper = nil
        usersNetworkService = nil
    }

    // MARK: - getUsers Tests

    func testGetUsersSuccess() async throws {
        // Given
        let page = "1"
        let results = 25
        let mockUsersDTO = createMockUsersDTO()
        let expectedUsersResponse = createMockUsersResponse()

        stub(mockAPIClient) { mock in
            when(mock.request(
                endpoint: any(),
                responseType: UsersDTO.self
            )).thenReturn(mockUsersDTO)
        }

        stub(mockMapper) { mock in
            when(mock.mapToDomain(mockUsersDTO)).thenReturn(expectedUsersResponse)
        }

        // When
        let result = try await usersNetworkService.getUsers(page: page, results: results)

        // Then
        XCTAssertEqual(result.users.count, 2)
        XCTAssertEqual(result.users[0].name?.first, "John")
        XCTAssertEqual(result.users[0].name?.last, "Doe")
        XCTAssertEqual(result.users[1].name?.first, "Jane")
        XCTAssertEqual(result.users[1].name?.last, "Smith")

        verify(mockAPIClient).request(
            endpoint: any(),
            responseType: UsersDTO.self
        )
        verify(mockMapper).mapToDomain(mockUsersDTO)
    }

    func testGetUsersWithNilPage() async throws {
        // Given
        let page: String? = nil
        let results = 25
        let mockUsersDTO = createMockUsersDTO()
        let expectedUsersResponse = createMockUsersResponse()

        stub(mockAPIClient) { mock in
            when(mock.request(
                endpoint: any(),
                responseType: UsersDTO.self
            )).thenReturn(mockUsersDTO)
        }

        stub(mockMapper) { mock in
            when(mock.mapToDomain(mockUsersDTO)).thenReturn(expectedUsersResponse)
        }

        // When
        let result = try await usersNetworkService.getUsers(page: page, results: results)

        // Then
        XCTAssertEqual(result.users.count, 2)
        verify(mockAPIClient).request(
            endpoint: any(),
            responseType: UsersDTO.self
        )
    }

    func testGetUsersWithDefaultResults() async throws {
        // Given
        let page = "2"
        let mockUsersDTO = createMockUsersDTO()
        let expectedUsersResponse = createMockUsersResponse()

        stub(mockAPIClient) { mock in
            when(mock.request(
                endpoint: any(),
                responseType: UsersDTO.self
            )).thenReturn(mockUsersDTO)
        }

        stub(mockMapper) { mock in
            when(mock.mapToDomain(mockUsersDTO)).thenReturn(expectedUsersResponse)
        }

        // When
        let result = try await usersNetworkService.getUsers(page: page)

        // Then
        XCTAssertEqual(result.users.count, 2)
        verify(mockAPIClient).request(
            endpoint: any(),
            responseType: UsersDTO.self
        )
    }

    func testGetUsersNetworkError() async throws {
        // Given
        let page = "1"
        let results = 25
        let networkError = NetworkError.unauthorized

        stub(mockAPIClient) { mock in
            when(mock.request(
                endpoint: any(),
                responseType: UsersDTO.self
            )).thenThrow(networkError)
        }

        // When & Then
        do {
            _ = try await usersNetworkService.getUsers(page: page, results: results)
            XCTFail("Expected network error")
        } catch let error as NetworkError {
            if case .unauthorized = error {
                // Expected error
            } else {
                XCTFail("Expected unauthorized error, got: \(error)")
            }
        }
    }

    // MARK: - getUser Tests

    func testGetUserSuccess() async throws {
        // Given
        let userId = "123"
        let mockUserDTO = createMockUserDTO()
        let expectedUserEntity = createMockUserEntity()

        stub(mockAPIClient) { mock in
            when(mock.request(
                endpoint: any(),
                responseType: UserDTO.self
            )).thenReturn(mockUserDTO)
        }

        stub(mockMapper) { mock in
            when(mock.mapToDomain(mockUserDTO)).thenReturn(expectedUserEntity)
        }

        // When
        let result = try await usersNetworkService.getUser(id: userId)

        // Then
        XCTAssertEqual(result.name?.first, "John")
        XCTAssertEqual(result.name?.last, "Doe")
        XCTAssertEqual(result.gender, "male")
        XCTAssertEqual(result.phone, "+1234567890")

        verify(mockAPIClient).request(
            endpoint: any(),
            responseType: UserDTO.self
        )
        verify(mockMapper).mapToDomain(mockUserDTO)
    }

    func testGetUserNetworkError() async throws {
        // Given
        let userId = "123"
        let networkError = NetworkError.notFound

        stub(mockAPIClient) { mock in
            when(mock.request(
                endpoint: any(),
                responseType: UserDTO.self
            )).thenThrow(networkError)
        }

        // When & Then
        do {
            _ = try await usersNetworkService.getUser(id: userId)
            XCTFail("Expected network error")
        } catch let error as NetworkError {
            if case .notFound = error {
                // Expected error
            } else {
                XCTFail("Expected not found error, got: \(error)")
            }
        }
    }

    // MARK: - Extension Methods Tests

    func testGetUsersWithIntPage() async throws {
        // Given
        let page = 2
        let results = 50
        let mockUsersDTO = createMockUsersDTO()
        let expectedUsersResponse = createMockUsersResponse()

        stub(mockAPIClient) { mock in
            when(mock.request(
                endpoint: any(),
                responseType: UsersDTO.self
            )).thenReturn(mockUsersDTO)
        }

        stub(mockMapper) { mock in
            when(mock.mapToDomain(mockUsersDTO)).thenReturn(expectedUsersResponse)
        }

        // When
        let result = try await usersNetworkService.getUsers(page: page, results: results)

        // Then
        XCTAssertEqual(result.users.count, 2)
        verify(mockAPIClient).request(
            endpoint: any(),
            responseType: UsersDTO.self
        )
    }

    func testGetFirstPageUsers() async throws {
        // Given
        let results = 10
        let mockUsersDTO = createMockUsersDTO()
        let expectedUsersResponse = createMockUsersResponse()

        stub(mockAPIClient) { mock in
            when(mock.request(
                endpoint: any(),
                responseType: UsersDTO.self
            )).thenReturn(mockUsersDTO)
        }

        stub(mockMapper) { mock in
            when(mock.mapToDomain(mockUsersDTO)).thenReturn(expectedUsersResponse)
        }

        // When
        let result = try await usersNetworkService.getFirstPageUsers(results: results)

        // Then
        XCTAssertEqual(result.users.count, 2)
        verify(mockAPIClient).request(
            endpoint: any(),
            responseType: UsersDTO.self
        )
    }

    func testGetDefaultUsers() async throws {
        // Given
        let mockUsersDTO = createMockUsersDTO()
        let expectedUsersResponse = createMockUsersResponse()

        stub(mockAPIClient) { mock in
            when(mock.request(
                endpoint: any(),
                responseType: UsersDTO.self
            )).thenReturn(mockUsersDTO)
        }

        stub(mockMapper) { mock in
            when(mock.mapToDomain(mockUsersDTO)).thenReturn(expectedUsersResponse)
        }

        // When
        let result = try await usersNetworkService.getDefaultUsers()

        // Then
        XCTAssertEqual(result.users.count, 2)
        verify(mockAPIClient).request(
            endpoint: any(),
            responseType: UsersDTO.self
        )
    }

    // MARK: - Helper Methods

    private func createMockUsersDTO() -> UsersDTO {
        return UsersDTO(
            results: [
                createMockUserDTO(),
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
    }

    private func createMockUserDTO() -> UserDTO {
        return UserDTO(
            gender: "male",
            name: NameDTO(title: "Mr", first: "John", last: "Doe"),
            dateOfBirth: DateOfBirthDTO(date: "1990-01-01", age: 33),
            phone: "+1234567890",
            picture: PictureDTO(large: "large.jpg", medium: "medium.jpg", thumbnail: "thumb.jpg"),
            nationality: "US"
        )
    }

    private func createMockUsersResponse() -> UsersResponse {
        return UsersResponse(
            users: [
                createMockUserEntity(),
                UserEntity(
                    id: UUID(),
                    gender: "female",
                    name: UserName(title: "Ms", first: "Jane", last: "Smith"),
                    dateOfBirth: UserDateOfBirth(date: "1992-05-15", age: 31),
                    phone: "+0987654321",
                    picture: UserPicture(large: "large2.jpg", medium: "medium2.jpg", thumbnail: "thumb2.jpg"),
                    nationality: "CA",
                    isSaved: false
                )
            ],
            info: ResponseInfo(seed: "test", results: 2, page: 1, version: "1.0")
        )
    }

    private func createMockUserEntity() -> UserEntity {
        return UserEntity(
            id: UUID(),
            gender: "male",
            name: UserName(title: "Mr", first: "John", last: "Doe"),
            dateOfBirth: UserDateOfBirth(date: "1990-01-01", age: 33),
            phone: "+1234567890",
            picture: UserPicture(large: "large.jpg", medium: "medium.jpg", thumbnail: "thumb.jpg"),
            nationality: "US",
            isSaved: false
        )
    }
}
