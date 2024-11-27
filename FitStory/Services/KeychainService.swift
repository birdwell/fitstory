import Security
import Foundation

enum KeychainError: Error {
    case invalidData
    case saveFailed
    case readFailed
    case deleteFailed
}

class KeychainService {
    static let shared = KeychainService()

    private init() {}

    func save(_ data: String, for key: String) throws {
        guard let data = data.data(using: .utf8) else { throw KeychainError.invalidData }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ] as CFDictionary

        // Delete existing item before adding new one
        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            throw KeychainError.saveFailed
        }
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
            return nil
        } else if status != errSecSuccess {
            throw KeychainError.readFailed
        }

        guard let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }

        return string
    }

    func delete(_ key: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.deleteFailed
        }
    }
}
