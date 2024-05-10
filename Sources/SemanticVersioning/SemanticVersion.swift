public struct SemanticVersion: Codable, Sendable {
    public init(major: Int, minor: Int, patch: Int, preRelease: String? = nil, build: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.preRelease = preRelease.map(PreRelease.init(identifier:))
        self.build = build
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let versionString = try container.decode(String.self)
        self = try SemanticVersioningDecoder().decode(from: versionString)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        let value = SemanticVersioningEncoder().encode(self)
        try container.encode(value)
    }
    
    public var major: Int
    public var minor: Int
    public var patch: Int
    public var preRelease: PreRelease?
    public var build: String?
}

public struct PreRelease: Sendable {
    public init(identifier: String) {
        self.identifiers = identifier.split(separator: ".")
    }
    
    public var identifiers: [Substring]
}

extension SemanticVersion: Comparable {
    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major // 1.0.0 < 2.0.0
        }
        if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor // 1.1.0 < 1.2.0
        }
        if lhs.patch != rhs.patch {
            return lhs.patch < rhs.patch // 1.0.0 < 1.0.1
        }
        switch (lhs.preRelease, rhs.preRelease) {
        case (nil, _):
            return false // 1.0.0 > 1.0.0-alpha
        case (_?, nil):
            return true // 1.0.0-alpha < 1.0.0
        case (let lhsPreRelease?, let rhsPreRelease?):
            return lhsPreRelease < rhsPreRelease // 1.0.0-alpha < 1.0.0-alpha.1
        }
    }
}

extension PreRelease: Comparable {
    public static func < (lhs: PreRelease, rhs: PreRelease) -> Bool {
        let lhsIDs = lhs.identifiers
        let rhsIDs = rhs.identifiers
        if lhsIDs.count < rhsIDs.count { // 1.0.0-alpha < 1.0.0-alpha.1
            return true
        }
        for i in rhsIDs.indices {
            let lhsID = lhsIDs[i]
            let rhsID = rhsIDs[i]
            let lhsIntID = Int(lhsID)
            let rhsIntID = Int(rhsID)
            switch (lhsIntID, rhsIntID) {
            case (.some, .none):
                // 1.0.0-1 < 1.0.0-alpha
                return true
            case (.none, .some):
                // 1.0.0-alpha > 1.0.0-1
                return false
            case (.some(let lhsIntID), .some(let rhsIntID)):
                // 1.0.0-1 < 1.0.0-2
                return lhsIntID < rhsIntID
            case (.none, .none):
                // 1.0.0-alpha < 1.0.0-beta
                if lhsID < rhsID {
                    return true
                }
            }
        }
        return false
    }
}

public extension SemanticVersion {
    static var zero: SemanticVersion { .init(major: 0, minor: 0, patch: 0) }
}
