//
//  UsersListViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import Combine

protocol UserListNavigation: AnyObject {
    func navigateToUserDetails(selectedUserData: User)
}
class UsersListViewModel {
    weak var navigation: UserListNavigation!
    @Published var users: [User] = []
    init(nav: UserListNavigation) {
        self.navigation = nav
    }

    func onAppear() {
        Task {
            await request()
        }
    }

    func navigateToUserDetails(index: Int) {
        navigation.navigateToUserDetails(selectedUserData: users[index])
    }

    func request() async {
        do {
            let data = try await fetchDataFromAPI()
            users = data.results
            print("Received data: \(data.results.count) bytes")
        } catch {
            switch error {
            case NetworkError.invalidURL:
                print("Invalid URL")
            case NetworkError.requestFailed(let underlyingError):
                print("Request failed with error: \(underlyingError.localizedDescription)")
            case NetworkError.invalidResponse:
                print("Invalid response")
            case NetworkError.non200StatusCode(let statusCode):
                print("HTTP Response Error: \(statusCode)")
            default:
                print("Unknown error: \(error)")
            }
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case non200StatusCode(Int)
    case noData
}

func fetchDataFromAPI() async throws -> Users {
    guard let url = URL(string: "https://randomuser.me/api/?results=25") else {
        throw NetworkError.invalidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.invalidResponse
    }

    if httpResponse.statusCode == 200 {
        let users = try JSONDecoder().decode(Users.self, from: data)
        print(users)
         return users
    } else {
        throw NetworkError.non200StatusCode(httpResponse.statusCode)
    }
}
