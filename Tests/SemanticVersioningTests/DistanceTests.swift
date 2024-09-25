import Testing
@testable import SemanticVersioning

@Suite
struct DistanceTests {
    @Test
    func major() {
        let currentVersion = SemanticVersion(
            major: 1,
            minor: 0,
            patch: 0
        )
        let newVersion = SemanticVersion(
            major: 2,
            minor: 5,
            patch: 0
        )
        let distance = currentVersion.distance(to: newVersion)
        #expect(distance == .major(1))
    }
    
    @Test
    func minor() {
        let currentVersion = SemanticVersion(
            major: 1,
            minor: 0,
            patch: 0
        )
        let newVersion = SemanticVersion(
            major: 1,
            minor: 5,
            patch: 0
        )
        let distance = currentVersion.distance(to: newVersion)
        #expect(distance == .minor(5))
    }
    
    @Test
    func path() {
        let currentVersion = SemanticVersion(
            major: 1,
            minor: 0,
            patch: 9
        )
        let newVersion = SemanticVersion(
            major: 1,
            minor: 0,
            patch: 22
        )
        let distance = currentVersion.distance(to: newVersion)
        #expect(distance == .patch(13))
    }
    
    @Test
    func same() {
        let currentVersion = SemanticVersion(
            major: 1,
            minor: 0,
            patch: 0
        )
        let newVersion = SemanticVersion(
            major: 1,
            minor: 0,
            patch: 0
        )
        let distance = currentVersion.distance(to: newVersion)
        #expect(distance == nil)
    }
}
