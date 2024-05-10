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

# Apps Using

<p float="left">
    <a href="https://apps.apple.com/app/id1668645019"><img src="https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/a4/90/d4/a490d494-0ba3-9e1f-5c09-cc6ece22d978/AppIcon-1x_U007epad-0-P3-85-220-0.png/512x512bb.jpg" height="65"></a>
</p>

# License

SemanticVersioning is available under the MIT license. See the LICENSE file for more info.
