import Foundation

public struct SemanticVersioningEncoder: Sendable {
    public init() {}
    
    public func encode(_ semanticVersion: SemanticVersion) -> String {
        var value: String = ""
        let versionCore = [
            semanticVersion.major,
            semanticVersion.minor,
            semanticVersion.patch
        ].map({ String($0) }).joined(separator: ".")
        value += versionCore
        if let preRelease = semanticVersion.preRelease {
            value += "-" + preRelease.identifiers.joined(separator: ".")
        }
        if let build = semanticVersion.build {
            value += "+" + build
        }
        return value
    }
}
