import Security
import Foundation

class KeychainService {
    static let shared = KeychainService()

    private init() {}

    func save(_ data: String, for key: String) throws {
        guard let data = data.data(using: .utf8) else { throw KeychainError.invalidData }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrService as String: "birdwell.FitStory",
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock // Adjusted for longer persistence
        ] as CFDictionary

        // Delete existing item before adding a new one
        SecItemDelete(query)

        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            throw KeychainError.saveFailed
        }

        print("[KeychainService] Successfully saved key: \(key) with long-term accessibility.")
    }

    func read(_ key: String) throws -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        if status == errSecItemNotFound {
            print("[KeychainService] Key not found: \(key)")
            return nil
        } else if status != errSecSuccess {
            throw KeychainError.readFailed
        }

        if let data = result as? Data, let string = String(data: data, encoding: .utf8) {
            print("[KeychainService] Successfully read key: \(key)")
            return string
        } else {
            throw KeychainError.invalidData
        }
    }

    func delete(_ key: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        let status = SecItemDelete(query)
        if status == errSecItemNotFound {
            print("[KeychainService] Key not found for deletion: \(key)")
        } else if status != errSecSuccess {
            throw KeychainError.deleteFailed
        } else {
            print("[KeychainService] Successfully deleted key: \(key)")
        }
    }
}

enum KeychainError: Error {
    case invalidData
    case saveFailed
    case readFailed
    case deleteFailed
}
