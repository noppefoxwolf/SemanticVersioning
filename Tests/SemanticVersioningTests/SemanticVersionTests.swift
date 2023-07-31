import XCTest
@testable import SemanticVersioning

class SemanticVersionTests: XCTestCase {
    func testCodable() async throws {
        let json = ##"{"semanticVersion":"1.2.0-alpha.11+feddcc"}"##
        struct Version: Codable {
            let semanticVersion: SemanticVersion
        }
        let jsonDecoder = JSONDecoder()
        let decoded = try jsonDecoder.decode(Version.self, from: Data(json.utf8))
        XCTAssertEqual(decoded.semanticVersion.major, 1)
        
        let jsonEncoder = JSONEncoder()
        let encoded = try jsonEncoder.encode(decoded)
        let encodedJSON = String(data: encoded, encoding: .utf8)!
        XCTAssertEqual(encodedJSON, json)
    }
    
    func testEqual() async throws {
        let v100_A = SemanticVersion(major: 1, minor: 0, patch: 0)
        let v100_B = SemanticVersion(major: 1, minor: 0, patch: 0)
        XCTAssertEqual(v100_A, v100_B)
    }
    
    func testOrder() async throws {
        //  1.0.0 < 2.0.0 < 2.1.0 < 2.1.1
        let v100 = SemanticVersion(
            major: 1,
            minor: 0,
            patch: 0
        )
        let v200 = SemanticVersion(
            major: 2,
            minor: 0,
            patch: 0
        )
        let v210 = SemanticVersion(
            major: 2,
            minor: 1,
            patch: 0
        )
        let v211 = SemanticVersion(
            major: 2,
            minor: 1,
            patch: 1
        )

        XCTAssertGreaterThan(v211, v210)
        XCTAssertGreaterThan(v210, v200)
        XCTAssertGreaterThan(v200, v100)
    }
    
    func testPreReleasedOrder() async throws {
        let v100Alpha = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "alpha")
        let v100 = SemanticVersion(major: 1, minor: 0, patch: 0)
        XCTAssertGreaterThan(v100, v100Alpha)
    }
    
    func testAsciiPreReleasedOrder() async throws {
        let v100Alpha = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "alpha")
        let v100Alpha1 = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "alpha.1")
        let v100AlphaBeta = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "alpha.beta")
        let v100Beta = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "beta")
        let v100Beta2 = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "beta.2")
        let v100Beta11 = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "beta.11")
        let v100RC1 = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "rc.1")
        let v100 = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: nil)
        XCTAssertGreaterThan(v100, v100RC1)
        XCTAssertGreaterThan(v100RC1, v100Beta11)
        XCTAssertGreaterThan(v100Beta11, v100Beta2)
        XCTAssertGreaterThan(v100Beta2, v100Beta)
        XCTAssertGreaterThan(v100Beta, v100AlphaBeta)
        XCTAssertGreaterThan(v100AlphaBeta, v100Alpha1)
        XCTAssertGreaterThan(v100Alpha1, v100Alpha)
    }
}

