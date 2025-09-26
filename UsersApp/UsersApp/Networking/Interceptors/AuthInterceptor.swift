//
//  AuthInterceptor.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

/// Authentication interceptor that automatically adds auth tokens to requests
final class AuthInterceptor: InterceptorProtocol, Sendable {
    // MARK: - Properties
    private let tokenProvider: TokenProvider
    private let authHeaderName: String
    private let tokenPrefix: String

    // MARK: - Initialization
    init(
        tokenProvider: TokenProvider,
        authHeaderName: String = "Authorization",
        tokenPrefix: String = "Bearer"
    ) {
        self.tokenProvider = tokenProvider
        self.authHeaderName = authHeaderName
        self.tokenPrefix = tokenPrefix
    }

    // MARK: - InterceptorProtocol Implementation
    func intercept(request: URLRequest) async throws -> URLRequest {
        guard let token = await tokenProvider.getToken() else {
            return request // No token available, proceed without auth
        }

        var modifiedRequest = request
        let authHeaderValue = tokenPrefix.isEmpty ? token : "\(tokenPrefix) \(token)"
        modifiedRequest.setValue(authHeaderValue, forHTTPHeaderField: authHeaderName)

        return modifiedRequest
    }

    func intercept(data: Data, response: URLResponse, for request: URLRequest) async throws -> Data {
        // Check if we received 401 Unauthorized
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 401 {

            // Try to refresh the token
            let refreshed = await tokenProvider.refreshToken()
            if refreshed {
                // Token was refreshed, but we don't retry the request here
                // The client should handle retries at a higher level
                throw NetworkError.unauthorized
            } else {
                // Could not refresh token
                await tokenProvider.clearToken()
                throw NetworkError.unauthorized
            }
        }

        return data
    }
}

// MARK: - TokenProvider Protocol
protocol TokenProvider: Sendable {
    /// Gets the current authentication token
    func getToken() async -> String?

    /// Refreshes the authentication token
    /// - Returns: true if refresh was successful, false otherwise
    func refreshToken() async -> Bool

    /// Clears the stored token (e.g., on logout)
    func clearToken() async

    /// Stores a new token
    func setToken(_ token: String) async
}

// MARK: - Default TokenProvider Implementation
actor DefaultTokenProvider: TokenProvider {
    private var currentToken: String?
    private var refreshToken: String?
    private let refreshEndpoint: EndpointProtocol?
    private let storage: TokenStorage

    init(
        storage: TokenStorage = KeychainTokenStorage(),
        refreshEndpoint: EndpointProtocol? = nil
    ) {
        self.storage = storage
        self.refreshEndpoint = refreshEndpoint
        self.currentToken = nil
        self.refreshToken = nil

        // Initialize tokens asynchronously after init
        Task {
            await self.loadStoredTokens()
        }
    }

    private func loadStoredTokens() async {
        self.currentToken = await storage.getToken()
        self.refreshToken = await storage.getRefreshToken()
    }

    func getToken() async -> String? {
        if currentToken == nil {
            await loadStoredTokens()
        }
        return currentToken
    }

    func refreshToken() async -> Bool {
        // Get refresh token from memory or storage
        let refreshTokenValue: String
        if let memoryToken = self.refreshToken {
            refreshTokenValue = memoryToken
        } else if let storageToken = await storage.getRefreshToken() {
            refreshTokenValue = storageToken
            self.refreshToken = storageToken
        } else {
            return false
        }

        guard let endpoint = refreshEndpoint else {
            return false
        }

        // Create a simple refresh request
        // In a real implementation, you would use your APIClient here
        guard let url = endpoint.url else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("Bearer \(refreshTokenValue)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return false
            }

            // Parse the new token from response
            if let tokenResponse = try? JSONDecoder().decode(TokenResponse.self, from: data) {
                await setToken(tokenResponse.accessToken)
                if let newRefreshToken = tokenResponse.refreshToken {
                    self.refreshToken = newRefreshToken
                    await storage.setRefreshToken(newRefreshToken)
                }
                return true
            }
        } catch {
            print("Token refresh failed: \(error)")
        }

        return false
    }

    func clearToken() async {
        currentToken = nil
        refreshToken = nil
        await storage.clearTokens()
    }

    func setToken(_ token: String) async {
        currentToken = token
        await storage.setToken(token)
    }

    func setRefreshToken(_ token: String) async {
        refreshToken = token
        await storage.setRefreshToken(token)
    }
}

// MARK: - TokenStorage Protocol
protocol TokenStorage: Sendable {
    func getToken() async -> String?
    func setToken(_ token: String) async
    func getRefreshToken() async -> String?
    func setRefreshToken(_ token: String) async
    func clearTokens() async
}

// MARK: - Keychain TokenStorage Implementation
final class KeychainTokenStorage: TokenStorage, Sendable {
    private let tokenKey = "auth_token"
    private let refreshTokenKey = "refresh_token"

    func getToken() async -> String? {
        return getKeychainValue(for: tokenKey)
    }

    func setToken(_ token: String) async {
        setKeychainValue(token, for: tokenKey)
    }

    func getRefreshToken() async -> String? {
        return getKeychainValue(for: refreshTokenKey)
    }

    func setRefreshToken(_ token: String) async {
        setKeychainValue(token, for: refreshTokenKey)
    }

    func clearTokens() async {
        deleteKeychainValue(for: tokenKey)
        deleteKeychainValue(for: refreshTokenKey)
    }

    // MARK: - Private Keychain Methods
    private func getKeychainValue(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }

    private func setKeychainValue(_ value: String, for key: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        // Try to update first
        let updateQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let updateAttributes: [String: Any] = [
            kSecValueData as String: data
        ]

        let updateStatus = SecItemUpdate(updateQuery as CFDictionary, updateAttributes as CFDictionary)

        if updateStatus == errSecItemNotFound {
            // Item doesn't exist, create it
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    private func deleteKeychainValue(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - TokenResponse Model
private struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}
