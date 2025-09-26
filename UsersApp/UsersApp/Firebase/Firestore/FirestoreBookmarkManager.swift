//
//  FirestoreBookmarkManager.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 3.09.2023.
//

import Foundation
import FirebaseFirestore

protocol FirestoreBookmarkManagerProtocol {
    func syncBookmarks(userId: String, bookmarks: [BookmarkData]) async -> Result<Void, BookmarkSyncError>
    func fetchBookmarks(userId: String) async -> Result<[BookmarkData], BookmarkSyncError>
    func addBookmark(userId: String, bookmark: BookmarkData) async -> Result<Void, BookmarkSyncError>
    func removeBookmark(userId: String, bookmarkId: String) async -> Result<Void, BookmarkSyncError>
    func enableRealtimeSync(userId: String, onUpdate: @escaping ([BookmarkData]) -> Void) -> ListenerRegistration?
}

class FirestoreBookmarkManager: FirestoreBookmarkManagerProtocol {
    private let database = Firestore.firestore()
    private let environmentManager: EnvironmentManagerProtocol
    private let remoteConfigManager: RemoteConfigManagerProtocol

    init(environmentManager: EnvironmentManagerProtocol = EnvironmentManager.shared,
         remoteConfigManager: RemoteConfigManagerProtocol = RemoteConfigManager.shared) {
        self.environmentManager = environmentManager
        self.remoteConfigManager = remoteConfigManager
    }

    private var bookmarksCollection: CollectionReference {
        return database.collection("bookmarks")
    }

    private func userBookmarksDocument(userId: String) -> DocumentReference {
        return bookmarksCollection.document(userId)
    }

    func syncBookmarks(userId: String, bookmarks: [BookmarkData]) async -> Result<Void, BookmarkSyncError> {
        guard remoteConfigManager.isBookmarkSyncEnabled else {
            return .failure(.featureDisabled)
        }

        do {
            let bookmarksData = bookmarks.map { $0.toDictionary() }
            let syncData: [String: Any] = [
                "bookmarks": bookmarksData,
                "lastUpdated": FieldValue.serverTimestamp(),
                "environment": environmentManager.currentEnvironment.rawValue,
                "deviceId": getDeviceIdentifier()
            ]

            try await userBookmarksDocument(userId: userId).setData(syncData, merge: true)

            environmentManager.infoLog("📚 Bookmarks synced successfully for user: \(userId)")
            return .success(())

        } catch {
            environmentManager.errorLog("📚 Bookmark sync failed: \(error.localizedDescription)")
            return .failure(.syncFailed(error))
        }
    }

    func fetchBookmarks(userId: String) async -> Result<[BookmarkData], BookmarkSyncError> {
        guard remoteConfigManager.isBookmarkSyncEnabled else {
            return .failure(.featureDisabled)
        }

        do {
            let document = try await userBookmarksDocument(userId: userId).getDocument()

            guard document.exists,
                  let data = document.data(),
                  let bookmarksArray = data["bookmarks"] as? [[String: Any]] else {
                return .success([]) // No bookmarks found
            }

            let bookmarks = bookmarksArray.compactMap { BookmarkData.fromDictionary($0) }

            environmentManager.infoLog("📚 Fetched \(bookmarks.count) bookmarks for user: \(userId)")
            return .success(bookmarks)

        } catch {
            environmentManager.errorLog("📚 Bookmark fetch failed: \(error.localizedDescription)")
            return .failure(.fetchFailed(error))
        }
    }

    func addBookmark(userId: String, bookmark: BookmarkData) async -> Result<Void, BookmarkSyncError> {
        guard remoteConfigManager.isBookmarkSyncEnabled else {
            return .failure(.featureDisabled)
        }

        do {
            try await userBookmarksDocument(userId: userId).updateData([
                "bookmarks": FieldValue.arrayUnion([bookmark.toDictionary()]),
                "lastUpdated": FieldValue.serverTimestamp()
            ])

            environmentManager.infoLog("📚 Bookmark added for user: \(userId)")
            return .success(())

        } catch {
            environmentManager.errorLog("📚 Add bookmark failed: \(error.localizedDescription)")
            return .failure(.addFailed(error))
        }
    }

    func removeBookmark(userId: String, bookmarkId: String) async -> Result<Void, BookmarkSyncError> {
        guard remoteConfigManager.isBookmarkSyncEnabled else {
            return .failure(.featureDisabled)
        }

        // First fetch the bookmark to remove
        let fetchResult = await fetchBookmarks(userId: userId)

        switch fetchResult {
        case .success(let bookmarks):
            guard let bookmarkToRemove = bookmarks.first(where: { $0.id == bookmarkId }) else {
                return .failure(.bookmarkNotFound)
            }

            do {
                try await userBookmarksDocument(userId: userId).updateData([
                    "bookmarks": FieldValue.arrayRemove([bookmarkToRemove.toDictionary()]),
                    "lastUpdated": FieldValue.serverTimestamp()
                ])

                environmentManager.infoLog("📚 Bookmark removed for user: \(userId)")
                return .success(())

            } catch {
                environmentManager.errorLog("📚 Remove bookmark failed: \(error.localizedDescription)")
                return .failure(.removeFailed(error))
            }

        case .failure(let error):
            return .failure(error)
        }
    }

    func enableRealtimeSync(userId: String, onUpdate: @escaping ([BookmarkData]) -> Void) -> ListenerRegistration? {
        guard remoteConfigManager.isBookmarkSyncEnabled else {
            environmentManager.warningLog("📚 Realtime sync attempted but feature is disabled")
            return nil
        }

        let listener = userBookmarksDocument(userId: userId).addSnapshotListener { [weak self] document, error in
            if let error = error {
                self?.environmentManager.errorLog("📚 Realtime sync error: \(error.localizedDescription)")
                return
            }

            guard let document = document,
                  document.exists,
                  let data = document.data(),
                  let bookmarksArray = data["bookmarks"] as? [[String: Any]] else {
                onUpdate([])
                return
            }

            let bookmarks = bookmarksArray.compactMap { BookmarkData.fromDictionary($0) }
            onUpdate(bookmarks)
        }

        environmentManager.infoLog("📚 Realtime sync enabled for user: \(userId)")
        return listener
    }

    private func getDeviceIdentifier() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device"
    }
}

// MARK: - Bookmark Data Model
struct BookmarkData: Codable {
    let id: String
    let userId: String
    let userName: String
    let userAge: String?
    let userNationality: String?
    let userPictureUrl: String?
    let bookmarkedAt: Date
    let environment: String

    // Manual initializer for all properties
    init(id: String,
         userId: String,
         userName: String,
         userAge: String?,
         userNationality: String?,
         userPictureUrl: String?,
         bookmarkedAt: Date,
         environment: String) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.userAge = userAge
        self.userNationality = userNationality
        self.userPictureUrl = userPictureUrl
        self.bookmarkedAt = bookmarkedAt
        self.environment = environment
    }

    init(from userEntity: UserEntity) {
        self.id = userEntity.id.uuidString
        self.userId = userEntity.id.uuidString
        self.userName = userEntity.fullName
        self.userAge = userEntity.dateOfBirth?.age?.description
        self.userNationality = userEntity.nationality
        self.userPictureUrl = userEntity.picture?.medium
        self.bookmarkedAt = Date()
        self.environment = EnvironmentManager.shared.currentEnvironment.rawValue
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "userId": userId,
            "userName": userName,
            "userAge": userAge ?? "",
            "userNationality": userNationality ?? "",
            "userPictureUrl": userPictureUrl ?? "",
            "bookmarkedAt": Timestamp(date: bookmarkedAt),
            "environment": environment
        ]
    }

    static func fromDictionary(_ dict: [String: Any]) -> BookmarkData? {
        guard let id = dict["id"] as? String,
              let userId = dict["userId"] as? String,
              let userName = dict["userName"] as? String,
              let environment = dict["environment"] as? String else {
            return nil
        }

        let userAge = dict["userAge"] as? String
        let userNationality = dict["userNationality"] as? String
        let userPictureUrl = dict["userPictureUrl"] as? String

        let bookmarkedAt: Date
        if let timestamp = dict["bookmarkedAt"] as? Timestamp {
            bookmarkedAt = timestamp.dateValue()
        } else {
            bookmarkedAt = Date()
        }

        return BookmarkData(
            id: id,
            userId: userId,
            userName: userName,
            userAge: userAge,
            userNationality: userNationality,
            userPictureUrl: userPictureUrl,
            bookmarkedAt: bookmarkedAt,
            environment: environment
        )
    }
}

// MARK: - Bookmark Sync Errors
enum BookmarkSyncError: Error, LocalizedError {
    case featureDisabled
    case syncFailed(Error)
    case fetchFailed(Error)
    case addFailed(Error)
    case removeFailed(Error)
    case bookmarkNotFound
    case invalidData
    case networkError

    var errorDescription: String? {
        switch self {
        case .featureDisabled:
            return "Bookmark sync feature is disabled"
        case .syncFailed(let error):
            return "Sync failed: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Fetch failed: \(error.localizedDescription)"
        case .addFailed(let error):
            return "Add failed: \(error.localizedDescription)"
        case .removeFailed(let error):
            return "Remove failed: \(error.localizedDescription)"
        case .bookmarkNotFound:
            return "Bookmark not found"
        case .invalidData:
            return "Invalid bookmark data"
        case .networkError:
            return "Network error occurred"
        }
    }
}
