//
//  NetworkServiceTest.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 29.09.2025.
//

import XCTest
import Cuckoo
@testable import UsersApp

final class UsersNetworkServiceTests: XCTestCase {

    var mockApiClient: MockNetworkClientProtocol!
    var mockMapper: MockUserMapperProtocol!
    var sut: UsersNetworkService!

    override func setUp() {
        super.setUp()
        mockApiClient = MockNetworkClientProtocol()
        mockMapper = MockUserMapperProtocol()
        sut = UsersNetworkService(apiClient: mockApiClient, mapper: mockMapper)
    }

    override func tearDown() {
        mockApiClient = nil
        mockMapper = nil
        sut = nil
        super.tearDown()
    }

    func test_getUsers_success() async throws {
        // Arrange
        let fakeDTO = UsersDTO(
            results: [],
            info: InfoDTO(seed: "seed", results: 0, page: 1, version: "1")
        )
        let expected = fakeDTO.toDomainEntity()
        
        stub(mockApiClient) { stub in
            when(stub.request(endpoint: any(), responseType: any()))
                .thenReturn(fakeDTO)
        }

        stub(mockMapper) { stub in
            when(stub.mapToDomain(any())).thenReturn(expected)
        }

        // Act
        let result = try await sut.getUsers(page: "1", results: 10)

        // Assert
        XCTAssertEqual(result.info.page, 1)
        verify(mockApiClient).request(endpoint: any(), responseType: any(UsersDTO.Type.self))
        verify(mockMapper).mapToDomain(any(UsersDTO.self))
    }
    
    func test_getUser_success() async throws {
        // Arrange
        let fakeDTO = UserDTO(
            gender: "male",
            name: NameDTO(title: "Mr", first: "John", last: "Doe"),
            dateOfBirth: DateOfBirthDTO(date: "1990-01-01", age: 33),
            phone: "+1234567890",
            picture: PictureDTO(large: "large.jpg", medium: "medium.jpg", thumbnail: "thumb.jpg"),
            nationality: "US"
        )
        let expected = fakeDTO.toDomainEntity()

        stub(mockApiClient) { stub in
            when(stub.request(endpoint: any(), responseType: any()))
                .thenReturn(fakeDTO)
        }

        stub(mockMapper) { stub in
            when(stub.mapToDomain(any(UserDTO.self))).thenReturn(expected)
        }

        // Act
        let result = try await sut.getUser(id: "123")

        // Assert
        XCTAssertEqual(result.name?.first, "John")
        verify(mockApiClient).request(endpoint: any(), responseType: any(UserDTO.Type.self))
        verify(mockMapper).mapToDomain(any(UserDTO.self))
    }
    
    func test_getUsers_failure_whenApiThrows() async throws {
        // Arrange
        stub(mockApiClient) { stub in
            when(stub.request(endpoint: any(), responseType: any(UsersDTO.Type.self)))
                .thenThrow(NetworkError.noData)
        }

        do {
            _ = try await sut.getUsers(page: "1", results: 10)
            XCTFail("Expected NetworkError.noData to be thrown, but succeeded")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }

        verify(mockApiClient).request(endpoint: any(), responseType: any(UsersDTO.Type.self))
        verifyNoMoreInteractions(mockMapper)
    }

    func test_getFirstPageUsers_callsGetUsersWithPage1() async throws {
        // Arrange
        let fakeDTO = UsersDTO(results: [], info: InfoDTO(seed: "seed", results: 0, page: 1, version: "1"))
        let expected = fakeDTO.toDomainEntity()

        stub(mockApiClient) { stub in
            when(stub.request(endpoint: any(), responseType: any())).thenReturn(fakeDTO)
        }
        stub(mockMapper) { stub in
            when(stub.mapToDomain(any(UsersDTO.self))).thenReturn(expected)
        }

        // Act
        let result = try await sut.getFirstPageUsers()

        // Assert
        XCTAssertEqual(result.info.page, 1)
        verify(mockApiClient).request(endpoint: any(), responseType: any(UsersDTO.Type.self))
        verify(mockMapper).mapToDomain(any(UsersDTO.self))
    }


}
