# AwesomeData

<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift" /></a>
<a href="https://tldrlegal.com/license/mit-license"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat" alt="License" /></a>
[![Version](https://img.shields.io/cocoapods/v/AwesomeData.svg?style=flat)](http://cocoapods.org/pods/AwesomeData)
[![License](https://img.shields.io/cocoapods/l/AwesomeData.svg?style=flat)](http://cocoapods.org/pods/AwesomeData)
[![Platform](https://img.shields.io/cocoapods/p/AwesomeData.svg?style=flat)](http://cocoapods.org/pods/AwesomeData)
### Continuous integration - branch master
[![CI Status Master](https://travis-ci.org/iOSWizards/AwesomeData.svg?branch=master)](https://travis-ci.org/iOSWizards/AwesomeData)
### Continuous integration - branch develop
[![CI Status](https://travis-ci.org/iOSWizards/AwesomeData.svg?branch=0.3.8)](https://travis-ci.org/iOSWizards/AwesomeData)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8 or Higher
Swift-3

## Installation

AwesomeData is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AwesomeData", git: 'https://github.com/iOSWizards/AwesomeData.git', tag: '0.3.9'
```

## Author

Evandro Hoffmann, evandro@itsdayoff.com

## Contributor

Leonardo Kaminski Ferreira, leonardo.kaminski.ferreira@gmail.com

## License

AwesomeData is available under the MIT license. See the LICENSE file for more info.

## Removing Coredata code from AppDelegate

Coredata code should never belong to AppDelegate file, so with the AwesomeData, you can have it from an external source.

## How to Use:

In AppDelegate:
- Delete the coredata code (everything below **func applicationWillTerminate(application: UIApplication)**)
- Import the library in **AppDelegate**
```swift
import AwesomeData
```
- Add to **didFinishLaunchingWithOptions**
```swift
AwesomeData.setDatabase("NAME OF YOUR DATABASE FILE WITHOUT EXTENSION")
//AwesomeData.showLogs = true
```
- Replace / Add to **applicationWillTerminate**
```swift
AwesomeData.saveContext()
```

## Fetching data from URL:

### Simple Fetch:

Fetch data from a URL with standard properties.

```swift
AwesomeFetcher.fetchData("YOUR URL STRING") { (data) in
    //process data
}
```

### Fetch with Method Type:

Fetch data from a URL with standard properties, but choosing the method type.

```swift
AwesomeFetcher.fetchData("YOUR URL STRING",
method: .GET/.POST/.PUT/.DELETE) { (data) in
    //process data
}
```

### Fetch with Method Type and Authorization code:

Fetch data from a URL with authorization code.

```swift
AwesomeFetcher.fetchData("YOUR URL STRING",
method: .GET/.POST/.PUT/.DELETE,
authorization: "AUTHORIZATION CODE") { (data) in
    //process data
}
```

### Fetch with Method Type and JSON Body:

Fetch data from URL with JSON Body

```swift
AwesomeFetcher.fetchData("YOUR URL STRING",
method: .GET/.POST/.PUT/.DELETE,
jsonBody: [String : AnyObject]?,
authorization: "AUTHORIZATION CODE") { (data) in
    //process data
}
```

### The complete Fetch request:

Fetch data from URL with any combination of properties.

```swift
AwesomeFetcher.fetchData("YOUR URL STRING",
method: .GET/.POST/.PUT/.DELETE,
bodyData: NSData?,
headerValues: [[String]]?,
shouldCache: Bool, completion: { (data) in
*process data*
}
```

## Parsing JSON data

Parse NSData into a Dictionary and parse to Coredata Object.

**Let's consider this Unsplash JSON object:**
```ruby
[{
"format":"jpeg",
"width":5616,
"height":3744,
"filename":"0000_yC-Yzbqy7PY.jpeg",
"id":0,
"author":"Alejandro Escamilla",
"author_url":"https://unsplash.com/@alejandroescamilla",
"post_url":"https://unsplash.com/photos/yC-Yzbqy7PY"},
{...}]
```

### NSData to JSON Dictionary

Gets JSON Object from NSData

```swift
let jsonObject = AwesomeParser.jsonObject(data)
```

### Parsing JSON Dictionary to Coredata Object

Consider you have the **UnsplashImage** Coredata object, to parse it, use one of the parsing helpers:
```swift
parseInt(jsonObject, key: "KEY")
parseDouble(jsonObject, key: "KEY")
parseString(jsonObject, key: "KEY")
parseDate(jsonObject, key: "KEY")
parseBool(jsonObject, key: "KEY")
```

```swift
let objectId = parseInt(jsonObject, key: "id")

//gets object with objectId, to make sure there is only one object in Coredata with that ID. If it's nil, create a new object and use it.
if let unsplashImage = getObject(predicate: NSPredicate(format: "objectId == %d", objectId.intValue), createIfNil: true) as? UnsplashImage {
unsplashImage.objectId = objectId
unsplashImage.width = parseDouble(jsonObject, key: "width")
unsplashImage.height = parseInt(jsonObject, key: "height")
unsplashImage.format = parseString(jsonObject, key: "format")
unsplashImage.filename = parseString(jsonObject, key: "filename")
unsplashImage.author = parseString(jsonObject, key: "author")
unsplashImage.authorUrl = parseString(jsonObject, key: "author_url")
unsplashImage.postUrl = parseString(jsonObject, key: "post_url")
}
```

DOCUMENTATION UNDER DEVELOPMENT…
