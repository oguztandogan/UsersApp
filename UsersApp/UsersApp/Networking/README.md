# Yeni Networking Katmanı

Bu dosya, Swift 6 uyumlu, Sendable ve thread-safe yeni networking katmanının kullanımını açıklar.

## 📁 Klasör Yapısı

```
Data/
├── Networking/
│   ├── Protocols/           # Network soyutlamaları
│   │   └── NetworkClientProtocol.swift
│   ├── Base/               # Temel yapı taşları
│   │   ├── APIClient.swift
│   │   ├── NetworkError.swift
│   │   └── HTTPMethod.swift
│   ├── Endpoints/          # API endpoint tanımları
│   │   ├── UserEndpoint.swift
│   │   └── BaseEndpoint.swift
│   ├── Interceptors/       # Middleware işlemleri
│   │   ├── AuthInterceptor.swift
│   │   └── LoggingInterceptor.swift
│   ├── Services/          # High-level network servisleri
│   │   └── UsersNetworkService.swift
│   └── URLSessionTransport.swift
├── Mappers/               # DTO <-> Entity dönüşümleri
│   └── UserMapper.swift
└── DTOs/                  # Network data transfer objects
    └── UserDTO.swift

Core/
├── Extensions/
│   └── URLRequest+Extensions.swift
├── Constants/
│   └── NetworkConstants.swift
└── Helpers/
```

## 🚀 Temel Kullanım

### 1. Basit API Çağrısı

```swift
// API client oluştur
let transport = URLSessionTransport.default()
let apiClient = APIClient(transport: transport)

// Endpoint tanımla
let endpoint = UserEndpoint.userList(page: "1", results: 25)

// İstek gönder
do {
    let usersDTO = try await apiClient.request(
        endpoint: endpoint,
        responseType: UsersDTO.self
    )
    let users = UserMapper.mapToDomain(usersDTO)
} catch {
    print("Error: \(error)")
}
```

### 2. Service Katmanı Kullanımı

```swift
// Service oluştur
let usersService = UsersNetworkServiceFactory.create()

// Kullanıcıları getir
do {
    let response = try await usersService.getUsers(page: 1, results: 25)
    print("Fetched \(response.users.count) users")
} catch {
    print("Failed to fetch users: \(error)")
}
```

### 3. Authentication ile Kullanım

```swift
// Token provider oluştur
let tokenProvider = DefaultTokenProvider()
await tokenProvider.setToken("your-auth-token")

// Auth ile service oluştur
let usersService = UsersNetworkServiceFactory.createWithAuth(
    tokenProvider: tokenProvider
)

// Authenticated request gönder
let response = try await usersService.getUsers(page: 1)
```

## 🔧 Gelişmiş Konfigürasyon

### Custom Interceptor Ekleme

```swift
// Custom interceptor oluştur
class CustomHeaderInterceptor: InterceptorProtocol {
    func intercept(request: URLRequest) async throws -> URLRequest {
        var modifiedRequest = request
        modifiedRequest.setValue("my-app", forHTTPHeaderField: "X-Client")
        return modifiedRequest
    }
    
    func intercept(data: Data, response: URLResponse, for request: URLRequest) async throws -> Data {
        return data
    }
}

// Interceptor'larla client oluştur
let interceptors: [InterceptorProtocol] = [
    AuthInterceptor(tokenProvider: tokenProvider),
    CustomHeaderInterceptor(),
    LoggingInterceptor.development()
]

let apiClient = APIClient(
    transport: URLSessionTransport.default(),
    interceptors: interceptors
)
```

### Custom Transport

```swift
// Test için mock transport
let mockResponses = [
    "https://randomuser.me/api": (mockData, mockResponse)
]
let mockTransport = MockTransport(mockResponses: mockResponses)
let testService = UsersNetworkServiceFactory.create(
    transport: mockTransport
)
```

## 🧪 Testing

### Unit Test Örneği

```swift
class UsersNetworkServiceTests: XCTestCase {
    func testGetUsers() async throws {
        // Mock response hazırla
        let mockUsersDTO = UsersDTO(results: [], info: InfoDTO())
        let mockData = try JSONEncoder().encode(mockUsersDTO)
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://randomuser.me/api")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        // Mock transport oluştur
        let mockTransport = MockTransport(mockResponses: [
            "https://randomuser.me/api": (mockData, mockResponse)
        ])
        
        // Test service oluştur
        let service = UsersNetworkServiceFactory.create(transport: mockTransport)
        
        // Test et
        let response = try await service.getUsers(page: 1)
        XCTAssertEqual(response.users.count, 0)
    }
}
```

## ⚙️ Dependency Injection

DI container'da yeni networking katmanı otomatik olarak yapılandırılmıştır:

```swift
// DataAssembly.swift içinde
container.register(UsersNetworkServiceProtocol.self) { resolver in
    UsersNetworkService(
        apiClient: resolver.resolve(NetworkClientProtocol.self)!,
        mapper: resolver.resolve(UserMapperProtocol.self)!
    )
}.inObjectScope(.container)
```

## 🔄 Migration Guide

### Eski Koddan Yeni Koda Geçiş

**Eski:**
```swift
let usersService = UsersService()
let result = await usersService.getUsers(pageNumber: "1")
switch result {
case .success(let users):
    // Handle success
case .failure(let error):
    // Handle error
}
```

**Yeni:**
```swift
let usersService = DependencyContainer.shared.resolve(UsersNetworkServiceProtocol.self)!
do {
    let response = try await usersService.getUsers(page: 1)
    // Handle success with response.users
} catch {
    // Handle error
}
```

## 🛡️ Error Handling

Yeni sistem comprehensive error handling sağlar:

```swift
do {
    let response = try await usersService.getUsers(page: 1)
} catch let networkError as NetworkError {
    switch networkError {
    case .unauthorized:
        // Handle auth error
    case .networkUnavailable:
        // Handle no internet
    case .decodingError(let decodingError):
        // Handle parsing error
    case .httpError(let statusCode, let data):
        // Handle HTTP errors
    default:
        // Handle other errors
    }
} catch {
    // Handle unexpected errors
}
```

## 📊 Logging ve Monitoring

Logging interceptor otomatik olarak request/response'ları loglar:

```swift
// Development için detaylı logging
let loggingInterceptor = LoggingInterceptor.development()

// Production için sadece error logging
let loggingInterceptor = LoggingInterceptor.production()

// File'a logging
let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    .appendingPathComponent("network.log")
let loggingInterceptor = LoggingInterceptor.withFileLogging(logFileURL: fileURL)
```

## 🔑 Key Features

- ✅ **Swift 6 Uyumlu**: Sendable protokolleri ve thread safety
- ✅ **Generic**: Herhangi bir API için kullanılabilir
- ✅ **Testable**: Mock transport ve dependency injection
- ✅ **Interceptors**: Request/response middleware sistemi
- ✅ **Type Safe**: Compile-time güvenlik
- ✅ **Error Handling**: Comprehensive error sistem
- ✅ **Logging**: Built-in request/response logging
- ✅ **Authentication**: Token yönetimi ve refresh
- ✅ **Async/Await**: Modern concurrency desteği

## 🚨 Önemli Notlar

1. **Thread Safety**: Tüm sınıflar Sendable conform eder
2. **Memory Management**: Actor pattern kullanımı ile memory safety
3. **Performance**: Async/await ile optimal performans
4. **Maintainability**: Clean architecture principles
5. **Scalability**: Yeni endpoint'ler ve servisler kolayca eklenebilir
