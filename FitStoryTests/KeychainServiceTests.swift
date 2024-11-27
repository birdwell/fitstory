import XCTest
@testable import FitStory

class KeychainServiceTests: XCTestCase {
    let keychainService = KeychainService.shared
    let testKey = "testKey"
    let testValue = "testValue"

    override func tearDown() {
        super.tearDown()
        // Ensure Keychain is clean after every test
        try? keychainService.delete(testKey)
    }

    func testSaveAndRead() {
        // Save a value to Keychain
        try? keychainService.save(testValue, for: testKey)

        // Read the value back
        let retrievedValue = try? keychainService.read(testKey)

        // Assert the saved and retrieved values match
        XCTAssertEqual(retrievedValue, testValue, "The value retrieved from Keychain does not match the value saved.")
    }

    func testDelete() {
        // Save a value to Keychain
        try? keychainService.save(testValue, for: testKey)

        // Delete the value
        try? keychainService.delete(testKey)

        // Attempt to read the value
        let retrievedValue = try? keychainService.read(testKey)

        // Assert the value is nil after deletion
        XCTAssertNil(retrievedValue, "The value should be nil after deletion from Keychain.")
    }

    func testReadNonexistentKey() {
        // Attempt to read a key that was never saved
        let retrievedValue = try? keychainService.read("nonexistentKey")

        // Assert the value is nil
        XCTAssertNil(retrievedValue, "Reading a nonexistent key should return nil.")
    }
}
