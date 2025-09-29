//
//  APIClient.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

final class APIClient: NetworkClientProtocol, Sendable {
    private let transport: NetworkTransportProtocol
    private let interceptors: [InterceptorProtocol]
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    init(
        transport: NetworkTransportProtocol,
        interceptors: [InterceptorProtocol] = [],
        jsonDecoder: JSONDecoder = JSONDecoder(),
        jsonEncoder: JSONEncoder = JSONEncoder()
    ) {
        self.transport = transport
        self.interceptors = interceptors
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder

        self.jsonDecoder.dateDecodingStrategy = .iso8601
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        self.jsonEncoder.dateEncodingStrategy = .iso8601
        self.jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
    }

    func request<T: Codable & Sendable>(
        endpoint: EndpointProtocol,
        responseType: T.Type
    ) async throws -> T {
        let data = try await performRequest(endpoint: endpoint)
        do {
            let decodedResponse = try jsonDecoder.decode(responseType, from: data)
            return decodedResponse
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.unknown(error)
        }
    }

    private func performRequest(endpoint: EndpointProtocol) async throws -> Data {
        var request = try buildURLRequest(from: endpoint)

        for interceptor in interceptors {
            request = try await interceptor.intercept(request: request)
        }

        let (data, response) = try await transport.performRequest(request)

        try validateResponse(response)

        var processedData = data
        for interceptor in interceptors {
            processedData = try await interceptor.intercept(
                data: processedData,
                response: response,
                for: request
            )
        }
        return processedData
    }

    private func buildURLRequest(from endpoint: EndpointProtocol) throws -> URLRequest {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL(endpoint.baseURL + endpoint.path)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = endpoint.timeoutInterval

        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = endpoint.body {
            request.httpBody = body
        }
        return request
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        let statusCode = httpResponse.statusCode

        switch statusCode {
        case 200 ... 299:
            break
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        default:
            throw NetworkError.from(httpStatusCode: statusCode)
        }
    }
}

extension APIClient {
    func request<T: Codable & Sendable, U: Encodable & Sendable>(
        endpoint: EndpointProtocol,
        body: U,
        responseType: T.Type
    ) async throws -> T {
        let encodedBody: Data
        do {
            encodedBody = try jsonEncoder.encode(body)
        } catch let encodingError as EncodingError {
            throw NetworkError.encodingError(encodingError)
        }
        let endpointWithBody = EndpointWithBody(
            baseEndpoint: endpoint,
            body: encodedBody
        )
        return try await request(endpoint: endpointWithBody, responseType: responseType)
    }

    func post<T: Codable & Sendable, U: Encodable & Sendable>(
        endpoint: EndpointProtocol,
        body: U,
        responseType: T.Type
    ) async throws -> T {
        let endpointWithMethod = EndpointWithMethod(
            baseEndpoint: endpoint,
            method: .POST
        )
        return try await request(
            endpoint: endpointWithMethod,
            body: body,
            responseType: responseType
        )
    }

    func put<T: Codable & Sendable, U: Encodable & Sendable>(
        endpoint: EndpointProtocol,
        body: U,
        responseType: T.Type
    ) async throws -> T {
        let endpointWithMethod = EndpointWithMethod(
            baseEndpoint: endpoint,
            method: .PUT
        )
        return try await request(
            endpoint: endpointWithMethod,
            body: body,
            responseType: responseType
        )
    }
}

private struct EndpointWithBody: EndpointProtocol {
    let baseEndpoint: EndpointProtocol
    let body: Data?
    var baseURL: String { baseEndpoint.baseURL }
    var path: String { baseEndpoint.path }
    var method: HTTPMethod { baseEndpoint.method }
    var headers: [String: String] { baseEndpoint.headers }
    var queryParameters: [String: String] { baseEndpoint.queryParameters }
    var timeoutInterval: TimeInterval { baseEndpoint.timeoutInterval }
}

private struct EndpointWithMethod: EndpointProtocol {
    let baseEndpoint: EndpointProtocol
    let method: HTTPMethod
    var baseURL: String { baseEndpoint.baseURL }
    var path: String { baseEndpoint.path }
    var headers: [String: String] { baseEndpoint.headers }
    var queryParameters: [String: String] { baseEndpoint.queryParameters }
    var body: Data? { baseEndpoint.body }
    var timeoutInterval: TimeInterval { baseEndpoint.timeoutInterval }
}
