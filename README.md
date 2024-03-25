# NetworkComponents
Swift components for network data exchange

# System minimal requirements:
iOS13, MacOS12 

# SPM Usage:
```swift
    dependencies: [.package(url: "https://github.com/Oleg-E-Bakharev/NetworkComponents", from: "1.0.0")]
```

# Contents
## EnumAlwaysDecodable
Protocol and extensions for always success decode enums even if they has unknown values.\
Supports only enum with string or int values
```swift
public protocol EnumAlwaysDecodable: Decodable {
    static var unparsed: Self { get }
}
```
### Usage:
```swift
enum SomeEnum: String, Decodable, EnumAlwaysDecodable {
    case first
    case second
    case unparsed // Required!
}
```
If while decoding met unknown enum value, result will 'unparsed'

## AnyPrimitiveCodable
Type, representable one of possible primitive types in JSON
Supported possible types are: Int, Double, String, Bool, Date in Swift ISO8601 format (yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ)
### Encoding usage:
```swift
struct SomeStruct: Encodable {
    let item: AnyPrimiiveCodable
}

let encoder = JSONEncoder()
encoder.dateEncodingStrategy = .iso8601 // You should always use ISO8601 date encoding strategy

let dataToEncode = SomeStruct(item: .int(0))
let json = try? jsonEncoder.encode(dataToEncode)
```
result:
```json
{
    "value": 0 
}
```
note: value in JSON may be any supported primitive type
### Decoding usage
``` swift
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601 // You should always use ISO8601 date dencoding strategy

let decodedData = try? decoder.(SomeStruct.self, from: json)
```
