
extension SemanticVersion {
    public enum Distance: Sendable, Equatable {
        case major(Int)
        case minor(Int)
        case patch(Int)
    }
    
    public func distance(to: SemanticVersion) -> Distance? {
        let distanceOfMajor = to.major - major
        if distanceOfMajor != 0 {
            return .major(distanceOfMajor)
        }
        let distanceOfMinor = to.minor - minor
        if distanceOfMinor != 0 {
            return .minor(distanceOfMinor)
        }
        let distanceOfPatch = to.patch - patch
        if distanceOfPatch != 0 {
            return .patch(distanceOfPatch)
        }
        return nil
    }
}
