# SemanticVersioning

![GitHub Actions](https://github.com/noppefoxwolf/SemanticVersioning/actions/workflows/swift.yml/badge.svg)

## Codable

```swift
let json = ##"{"semanticVersion":"1.2.0-alpha.11+feddcc"}"##
struct Version: Codable {
  let semanticVersion: SemanticVersion
}
let jsonDecoder = JSONDecoder()
let decoded = try jsonDecoder.decode(Version.self, from: Data(json.utf8))

decoded.semanticVersion.major // 1
decoded.semanticVersion.minor // 2
decoded.semanticVersion.patch // 0
decoded.semanticVersion.preRelease // alpha, 11
decoded.semanticVersion.build // feddcc
```

## Comparable

```swift
let semanticVersionA = SemanticVersion(...) // 1.0.0-beta.11
let semanticVersionB = SemanticVersion(...) // 1.0.0-rc.1
semanticVersionA < semanticVersionB
```
