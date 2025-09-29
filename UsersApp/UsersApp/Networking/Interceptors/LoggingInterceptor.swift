//
//  LoggingInterceptor.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 26.09.2025.
//

import Foundation

final class LoggingInterceptor: InterceptorProtocol, Sendable {
    private let logger: NetworkLogger
    private let logLevel: LogLevel
    private let includeHeaders: Bool
    private let includeBody: Bool
    private let bodyLogLimit: Int

    enum LogLevel: Int, Sendable, CaseIterable {
        case none = 0
        case error = 1
        case warning = 2
        case info = 3
        case debug = 4
        var emoji: String {
            switch self {
            case .none: return ""
            case .error: return "❌"
            case .warning: return "⚠️"
            case .info: return "ℹ️"
            case .debug: return "🐛"
            }
        }
    }

    init(
        logger: NetworkLogger = DefaultNetworkLogger(),
        logLevel: LogLevel = .info,
        includeHeaders: Bool = true,
        includeBody: Bool = true,
        bodyLogLimit: Int = 1000
    ) {
        self.logger = logger
        self.logLevel = logLevel
        self.includeHeaders = includeHeaders
        self.includeBody = includeBody
        self.bodyLogLimit = bodyLogLimit
    }

    func intercept(request: URLRequest) async throws -> URLRequest {
        guard logLevel != .none else { return request }
        let requestId = UUID().uuidString.prefix(8)
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "unknown"
        logger.log("🚀 [\(requestId)] \(method) \(url)", level: .info)
        if includeHeaders && logLevel.rawValue >= LogLevel.debug.rawValue {
            if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
                let headersString = headers.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
                logger.log("📋 [\(requestId)] Headers:\n\(headersString)", level: .debug)
            }
        }
        if includeBody && logLevel.rawValue >= LogLevel.debug.rawValue {
            if let body = request.httpBody, !body.isEmpty {
                let bodyString = formatBodyData(body)
                logger.log("📤 [\(requestId)] Request Body:\n\(bodyString)", level: .debug)
            }
        }

        var modifiedRequest = request
        modifiedRequest.setValue(String(requestId), forHTTPHeaderField: "X-Request-ID")
        return modifiedRequest
    }

    func intercept(data: Data, response: URLResponse, for request: URLRequest) async throws -> Data {
        guard logLevel != .none else { return data }
        let requestId = request.value(forHTTPHeaderField: "X-Request-ID") ?? "unknown"
        if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            let statusEmoji = getStatusEmoji(for: statusCode)
            let url = httpResponse.url?.absoluteString ?? "unknown"
            let logLevelForStatus = getLogLevel(for: statusCode)
            logger.log("\(statusEmoji) [\(requestId)] \(statusCode) \(url)", level: logLevelForStatus)
            if includeHeaders && logLevel.rawValue >= LogLevel.debug.rawValue {
                let headers = httpResponse.allHeaderFields
                if !headers.isEmpty {
                    let headersString = headers.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
                    logger.log("📋 [\(requestId)] Response Headers:\n\(headersString)", level: .debug)
                }
            }
            if includeBody && logLevel.rawValue >= LogLevel.debug.rawValue && !data.isEmpty {
                let bodyString = formatBodyData(data)
                logger.log("📥 [\(requestId)] Response Body:\n\(bodyString)", level: .debug)
            }

            if let requestStartTime = getRequestStartTime(from: request) {
                let responseTime = Date().timeIntervalSince(requestStartTime)
                let timeString = String(format: "%.2fms", responseTime * 1000)
                logger.log("⏱️ [\(requestId)] Response time: \(timeString)", level: .info)
            }
        }
        return data
    }

    private func formatBodyData(_ data: Data) -> String {
        let limitedData = data.count > bodyLogLimit ? data.prefix(bodyLogLimit) : data
        if let jsonString = formatAsJSON(limitedData) {
            let suffix = data.count > bodyLogLimit ? "\n... (truncated at \(bodyLogLimit) bytes)" : ""
            return jsonString + suffix
        } else if let string = String(data: limitedData, encoding: .utf8) {
            let suffix = data.count > bodyLogLimit ? "\n... (truncated at \(bodyLogLimit) bytes)" : ""
            return string + suffix
        } else {
            return "<Binary data: \(data.count) bytes>"
        }
    }

    private func formatAsJSON(_ data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return nil
        }
        return prettyString
    }

    private func getStatusEmoji(for statusCode: Int) -> String {
        switch statusCode {
        case 200 ... 299: return "✅"
        case 300 ... 399: return "🔄"
        case 400 ... 499: return "⚠️"
        case 500 ... 599: return "❌"
        default: return "❓"
        }
    }

    private func getLogLevel(for statusCode: Int) -> LogLevel {
        switch statusCode {
        case 200 ... 299: return .info
        case 300 ... 399: return .warning
        case 400 ... 499: return .warning
        case 500 ... 599: return .error
        default: return .error
        }
    }

    private func getRequestStartTime(from _: URLRequest) -> Date? {
        return nil
    }
}

protocol NetworkLogger: Sendable {
    func log(_ message: String, level: LoggingInterceptor.LogLevel)
}

final class DefaultNetworkLogger: NetworkLogger, Sendable {
    private let dateFormatter: DateFormatter
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
    }

    func log(_ message: String, level: LoggingInterceptor.LogLevel) {
        let timestamp = dateFormatter.string(from: Date())
        let logMessage = "[\(timestamp)] \(level.emoji) \(message)"
        #if DEBUG
            print(logMessage)
        #endif
    }
}

final class FileNetworkLogger: NetworkLogger, Sendable {
    private let fileURL: URL
    private let maxFileSize: Int
    private let dateFormatter: DateFormatter
    init(fileURL: URL, maxFileSize: Int = 10 * 1024 * 1024) {
        self.fileURL = fileURL
        self.maxFileSize = maxFileSize
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }

    func log(_ message: String, level: LoggingInterceptor.LogLevel) {
        let timestamp = dateFormatter.string(from: Date())
        let logMessage = "[\(timestamp)] \(level.emoji) \(message)\n"
        guard let data = logMessage.data(using: .utf8) else { return }
        Task {
            await writeToFile(data)
        }
    }

    private func writeToFile(_ data: Data) async {
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
                if let fileSize = attributes[.size] as? Int, fileSize > maxFileSize {
                    try rotateLogFile()
                }
            }

            if FileManager.default.fileExists(atPath: fileURL.path) {
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } else {
                try data.write(to: fileURL)
            }
        } catch {
            print("Failed to write log: \(error)")
        }
    }

    private func rotateLogFile() throws {
        let backupURL = fileURL.appendingPathExtension("backup")

        if FileManager.default.fileExists(atPath: backupURL.path) {
            try FileManager.default.removeItem(at: backupURL)
        }

        try FileManager.default.moveItem(at: fileURL, to: backupURL)
    }
}

extension LoggingInterceptor {
    static func development() -> LoggingInterceptor {
        return LoggingInterceptor(
            logLevel: .debug,
            includeHeaders: true,
            includeBody: true,
            bodyLogLimit: 2000
        )
    }

    static func production() -> LoggingInterceptor {
        return LoggingInterceptor(
            logLevel: .error,
            includeHeaders: false,
            includeBody: false
        )
    }

    static func withFileLogging(logFileURL: URL) -> LoggingInterceptor {
        return LoggingInterceptor(
            logger: FileNetworkLogger(fileURL: logFileURL),
            logLevel: .info,
            includeHeaders: true,
            includeBody: true
        )
    }
}
