import Testing
import Foundation
@testable import SemanticVersioning

@Suite
struct SemanticVersionTests {
    
    @Test
    func testCodable() async throws {
        let json = ##"{"semanticVersion":"1.2.0-alpha.11+feddcc"}"##
        struct Version: Codable {
            let semanticVersion: SemanticVersion
        }
        let jsonDecoder = JSONDecoder()
        let decoded = try jsonDecoder.decode(Version.self, from: Data(json.utf8))
        #expect(decoded.semanticVersion.major == 1)
        
        let jsonEncoder = JSONEncoder()
        let encoded = try jsonEncoder.encode(decoded)
        let encodedJSON = String(data: encoded, encoding: .utf8)!
        #expect(encodedJSON == json)
    }
    
    @Test
    func testEqual() async throws {
        let v100_A = SemanticVersion(major: 1, minor: 0, patch: 0)
        let v100_B = SemanticVersion(major: 1, minor: 0, patch: 0)
        #expect(v100_A == v100_B)
    }
    
    @Test
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

        #expect(!(v211 < v210))
        #expect(!(v210 < v200))
        #expect(!(v200 < v100))
    }
    
    @Test
    func testWrongOrder() async throws {
        //  1.2.0 < 2.0.0 < 2.0.1 < 2.1.0
        let v120 = SemanticVersion(
            major: 1,
            minor: 2,
            patch: 0
        )
        let v200 = SemanticVersion(
            major: 2,
            minor: 0,
            patch: 0
        )
        let v201 = SemanticVersion(
            major: 2,
            minor: 0,
            patch: 1
        )
        let v210 = SemanticVersion(
            major: 2,
            minor: 1,
            patch: 0
        )
        
        #expect(!(v210 < v201))
        #expect(!(v201 < v200))
        #expect(!(v200 < v120))
    }
    
    @Test
    func testPreReleasedOrder() async throws {
        // 1.0.0-alpha < 1.0.0 < 1.0.1-alpha
        let v100Alpha = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "alpha")
        let v100 = SemanticVersion(major: 1, minor: 0, patch: 0)
        let v101Alpha = SemanticVersion(major: 1, minor: 0, patch: 1, preRelease: "alpha")
        #expect(v100 > v100Alpha)
        #expect(v101Alpha > v100)
        #expect(v101Alpha > v100Alpha)
        
        #expect(!(v100 < v100Alpha))
        #expect(!(v101Alpha < v100))
        #expect(!(v101Alpha < v100Alpha))
    }
    
    @Test
    func testAsciiPreReleasedOrder() async throws {
        let v100Alpha = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "alpha")
        let v100Alpha1 = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "alpha.1")
        let v100AlphaBeta = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "alpha.beta")
        let v100Beta = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "beta")
        let v100Beta2 = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "beta.2")
        let v100Beta11 = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "beta.11")
        let v100RC1 = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: "rc.1")
        let v100 = SemanticVersion(major: 1, minor: 0, patch: 0, preRelease: nil)
        #expect(v100 > v100RC1)
        #expect(v100RC1 > v100Beta11)
        #expect(v100Beta11 > v100Beta2)
        #expect(v100Beta2 > v100Beta)
        #expect(v100Beta > v100AlphaBeta)
        #expect(v100AlphaBeta > v100Alpha1)
        #expect(v100Alpha1 > v100Alpha)
    }
    
    @Test
    func testInvalidVersion() async throws {
        let invalidVersion = "1.0.0.0"
        let decoder = SemanticVersioningDecoder()
        #expect(throws: (any Error).self, performing: {
            try decoder.decode(from: invalidVersion)
        })
    }
}

