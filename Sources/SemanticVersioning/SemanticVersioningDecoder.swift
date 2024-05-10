import RegexBuilder

// https://semver.org
public struct SemanticVersioningDecoder: Sendable {
    public init() {}
    public func decode(from string: String) throws -> SemanticVersion {
        let majorReference = Reference<Int>()
        let minorReference = Reference<Int>()
        let patchReference = Reference<Int>()
        let preReleaseReference = Reference<String?>()
        let buildReference = Reference<String?>()
        
        let numericIdentifier = Regex {
            ChoiceOf {
                "0"
                Regex {
                    ("1"..."9")
                    ZeroOrMore(.digit)
                }
            }
        }
        let alphanumericIdentifier = Regex {
            ZeroOrMore(.digit)
            CharacterClass(
                .anyOf("-"),
                ("a"..."z"),
                ("A"..."Z")
            )
            ZeroOrMore {
                CharacterClass(
                    .anyOf("-"),
                    ("0"..."9"),
                    ("a"..."z"),
                    ("A"..."Z")
                )
            }
        }
        
        let major = Regex {
            numericIdentifier
        }
        let minor = Regex {
            numericIdentifier
        }
        let patch = Regex {
            numericIdentifier
        }
        let versionCore = Regex {
            TryCapture(major, as: majorReference, transform: { Int($0) })
            "."
            TryCapture(minor, as: minorReference, transform: { Int($0) })
            "."
            TryCapture(patch, as: patchReference, transform: { Int($0) })
        }
        
        let preReleaseIdentifier = Regex {
            ChoiceOf {
                alphanumericIdentifier
                numericIdentifier
            }
        }
        let dotSeparatedPreReleaseIdentifiers = Regex {
            preReleaseIdentifier
            ZeroOrMore {
                Regex {
                    "."
                    preReleaseIdentifier // dotSeparatedPreReleaseIdentifiers
                }
            }
        }
        let preRelease = Regex {
            dotSeparatedPreReleaseIdentifiers
        }
        let buildIdentifier = Regex {
            ChoiceOf {
                alphanumericIdentifier
                OneOrMore(.digit)
            }
        }
        let dotSeparatedBuildIdentifiers = Regex {
            OneOrMore {
                buildIdentifier
            }
            ZeroOrMore {
                Regex {
                    "."
                    buildIdentifier
                }
            }
        }
        let build = Regex {
            dotSeparatedBuildIdentifiers
        }
        let regex = Regex {
            versionCore
            Optionally {
                Regex {
                    "-"
                    Capture(preRelease, as: preReleaseReference, transform: { String($0) })
                }
            }
            Optionally {
                Regex {
                    "+"
                    Capture(build, as: buildReference, transform: { String($0) })
                }
            }
        }
        
        guard let match = string.wholeMatch(of: regex) else {
            throw DecodingError.valueNotFound(
                SemanticVersion.self,
                DecodingError.Context(codingPath: [], debugDescription: string)
            )
        }
        
        return SemanticVersion(
            major: match[majorReference],
            minor: match[minorReference],
            patch: match[patchReference],
            preRelease: match[preReleaseReference],
            build: match[buildReference]
        )
    }
}

