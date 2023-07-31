import XCTest
@testable import SemanticVersioning

final class SemanticVersioningDecoderTests: XCTestCase {
    func testExample() throws {
        let string = "1.0.0"
        let version = try SemanticVersioningDecoder().decode(from: string)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
    }
    
    func testInitialVersion() throws {
        let string = "0.0.0"
        let version = try SemanticVersioningDecoder().decode(from: string)
        XCTAssertEqual(version.major, 0)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
    }
    
    func testPreRelease() throws {
        let versions = ["1.0.0-alpha", "1.0.0-alpha.1", "1.0.0-0.3.7", "1.0.0-x.7.z.92", "1.0.0-x-y-z.--"]
        for versionString in versions {
            let version = try SemanticVersioningDecoder().decode(from: versionString)
            XCTAssertNotNil(version)
        }
    }
    
    func testBuild() throws {
        let versions = ["1.0.0-alpha+001", "1.0.0+20130313144700", "1.0.0-beta+exp.sha.5114f85", "1.0.0+21AF26D3----117B344092BD"]
        for versionString in versions {
            let version = try SemanticVersioningDecoder().decode(from: versionString)
            XCTAssertNotNil(version)
        }
    }
    
    func testInvalidSemantics() throws {
        let string = "v1.2.3"
        XCTAssertThrowsError(try SemanticVersioningDecoder().decode(from: string))
    }
}

