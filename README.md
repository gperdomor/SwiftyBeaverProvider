[![Swift Version](https://img.shields.io/badge/Swift-3.1_--_4.0-brightgreen.svg)](https://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-2-brightgreen.svg)](https://vapor.codes)
[![SwiftyBeaver Version](https://img.shields.io/badge/SwiftyBeaver-1.x-brightgreen.svg)](https://github.com/SwiftyBeaver/SwiftyBeaver)
[![Linux Build Status](https://img.shields.io/circleci/project/github/vapor-community/swiftybeaver-provider.svg?label=CI)](https://circleci.com/gh/vapor-community/swiftybeaver-provider)
[![codecov](https://codecov.io/gh/vapor-community/swiftybeaver-provider/branch/master/graph/badge.svg)](https://codecov.io/gh/vapor-community/swiftybeaver-provider)
[![GitHub license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

# SwiftyBeaver Logging Provider for Vapor

Adds the powerful logging of [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver) to [Vapor](https://github.com/vapor/vapor) for server-side Swift 3 on Linux and Mac.

## Installation

Add this project to the `Package.swift` dependencies of your Vapor project:

```swift
    .Package(url: ".git", majorVersion: 2),
)
```

or for Swift 4:

```swift
  .package(url: "https://github.com/vapor-community/swiftybeaver-provider.git", .upToNextMajor(from: "2.0.0"))
```

## Setup

After you've added the SwiftyBeaver Provider package to your project, setting the provider up in code is easy.

### Add to Droplet

First, register the SwiftyBeaverProvider.Provider with your Droplet.

```swift
import Vapor
import SwiftyBeaverProvider

let drop = try Droplet()

try drop.addProvider(SwiftyBeaverProvider.Provider.self)

````

### Configure Droplet

Once the provider is added to your Droplet, you can configure it to use the SwiftyBeaver logger. Otherwise you still use the old console logger.

Config/droplet.json

```json
{
    "log": "swiftybeaver",
}
```

### Configure Destinations

If you run your application now, you will likely see an error that the SwiftyBeaver configuration file is missing. Let's add that now

#### Basic

The configuration consist of an array of destinations. Here is an example of a simple SwiftyBeaver configuration file to configure console, file and swiftybeaver platform destinations with their required properties.

Config/swiftybeaver.json

```json
[
    {
        "type": "console"
    },
    {
        "type": "file"
    },
    {
        "type": "platform",        
        "app": "YOUR_APP_ID",
        "secret": "YOUR_SECRET_ID",
        "key": "YOUR_ENCRYPTION_KEY"
    }
]
```

Aditional options:

| KEY   | AVAILABLE FOR | TYPE | OBSERVATION | 
|-------|---------------|------|-------------|
| async | console, file | Bool |             |
| levelString.debug | console, file | String |   |
| levelString.error | console, file | String |   |
| levelString.info | console, file | String |   |
| levelString.verbose | console, file | String |   |
| levelString.warning | console, file | String |   |
| path | file | String | path to the log file |
| minLevel | console, file, platform | String | values: verbose, debug, info, warning, error |
| threshold | platform | Int | min: 1, max: 1000 |

> Note: 
\
It's a good idea to store the SwiftyBeaver configuration file in the Config/secrets folder since it contains sensitive information.
\
\
To get more information about configuration options check the official [SwiftyBeaver docs](https://docs.swiftybeaver.com/)


## Use

```swift
drop.get("/") { request in

    drop.log.verbose("not so important")
    drop.log.debug("something to debug")
    drop.log.info("a nice information")
    drop.log.warning("oh no, that won’t be good")
    drop.log.error("ouch, an error did occur!")

    return "welcome!"
}

```

The `Routes.swift` in the included App folder contains more details. Please also see the SwiftyBeaver [destination docs](http://docs.swiftybeaver.com/category/8-logging-destinations) and how to set a [custom logging format](http://docs.swiftybeaver.com/category/19-advanced-topics).
<br/><br/>

## Output to Xcode 8 Console

<img src="https://cloud.githubusercontent.com/assets/564725/18640658/5e1ea16e-7e99-11e6-8fbf-706b3150c617.png" width="615">

[Learn more](http://docs.swiftybeaver.com/article/9-log-to-xcode-console) about colored logging to Xcode 8 Console.
<br/><br/>

## Output to File

<img src="https://cloud.githubusercontent.com/assets/564725/18640664/658667ac-7e99-11e6-9267-d7cd168fea47.png" width="802">


[Learn more](http://docs.swiftybeaver.com/article/10-log-to-file) about logging to file which is great for Terminal.app fans or to store logs on disk.
<br/><br/>

## Output to Cloud & Mac App

![swiftybeaver-demo1](https://cloud.githubusercontent.com/assets/564725/14846071/218c0646-0c62-11e6-92cb-e6e963b68724.gif)

[Learn more](http://docs.swiftybeaver.com/article/11-log-to-swiftybeaver-platform) about logging to the SwiftyBeaver Platform **during release!**
<br/><br/>

## Learn More

- [Website](https://swiftybeaver.com)
- [SwiftyBeaver Framework](https://github.com/SwiftyBeaver/SwiftyBeaver)
- [Documentation](http://docs.swiftybeaver.com/)
- [Medium Blog](https://medium.com/swiftybeaver-blog)
- [On Twitter](https://twitter.com/SwiftyBeaver)


Get support via Github Issues, email and our <b><a href="https://slack.swiftybeaver.com">public Slack channel</a></b>.
<br/><br/>

## Credits
This package is developed and maintained by [Gustavo Perdomo](https://github.com/gperdomor) with the collaboration of all vapor community.

## License

SwiftyBeaverProvider is released under the [MIT License](LICENSE).
