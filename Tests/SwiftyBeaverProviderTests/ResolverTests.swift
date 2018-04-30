//
//  ResolverTests.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 9/21/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftyBeaverProvider

final class ResolverTests: XCTestCase {
    var resolver: Resolver!

    override func setUp() {
        super.setUp()
        resolver = Resolver()
    }

    func testResolveConsoleDestination() throws {
        let console = ConsoleDestination()

        let config = DestinationConfig(type: .console, async: false, format: "$M", minLevel: .warning, levelString: LevelString(debug: "D", error: "E", info: "I", verbose: "V", warning: "W"))

        let destination = try resolver.resolveConsoleDestination(from: config)

        XCTAssertNotNil(destination)
        try assertCommonProperties(console, destination, config)
    }

    func testResolveFileDestination() throws {
        let file = FileDestination()

        let config = DestinationConfig(type: .file, async: false, format: "$MJ", minLevel: .debug, levelString: LevelString(debug: "D", error: "E", info: "I", verbose: "V", warning: "W"), path: "file-warnings.log")

        let destination = try resolver.resolveFileDestination(from: config)

        XCTAssertNotNil(destination)

        XCTAssertNotEqual(file.logFileURL, destination.logFileURL)
        XCTAssertTrue((destination.logFileURL?.absoluteString.hasSuffix("file-warnings.log"))!)

        try assertCommonProperties(file, destination, config)
    }

    func testInvalidFilePath() throws {
        let config = DestinationConfig(type: .file, async: nil, format: nil, minLevel: nil, levelString: nil, path: "")

        XCTAssertThrowsError(try resolver.resolveFileDestination(from: config))
    }

    func testResolvePlatformDestination() throws {
        let config = DestinationConfig(app: "APP_ID", secret: "SECRET_ID", key: "ENCRYPTION_KEY", threshold: 500, minLevel: .info, serverURL: URL(string: "https://google.com"), analyticsUserName: "custom-user")

        let platform = try resolver.resolvePlatformDestination(from: config)

        XCTAssertNotNil(platform)

        XCTAssertEqual(platform.appID, "APP_ID")
        XCTAssertEqual(platform.appSecret, "SECRET_ID")
        XCTAssertEqual(platform.encryptionKey, "ENCRYPTION_KEY")

        XCTAssertEqual(platform.sendingPoints.threshold, 500)
        XCTAssertEqual(platform.serverURL?.absoluteString, "https://google.com")
        XCTAssertEqual(platform.analyticsUserName, "custom-user")

        XCTAssertEqual(platform.minLevel, .info)
    }

    func testInvalidPlatformThreshold() throws {
        var config = DestinationConfig(app: "APP_ID", secret: "SECRET_ID", key: "ENCRYPTION_KEY", threshold: -1, minLevel: .info)

        XCTAssertThrowsError(try resolver.resolvePlatformDestination(from: config))

        config = DestinationConfig(app: "APP_ID", secret: "SECRET_ID", key: "ENCRYPTION_KEY", threshold: 1001, minLevel: .info)

        XCTAssertThrowsError(try resolver.resolvePlatformDestination(from: config))
    }

    func testInvalidPlatformApp() throws {
        let config = DestinationConfig(app: "", secret: "SECRET_ID", key: "ENCRYPTION_KEY", threshold: nil)

        XCTAssertThrowsError(try resolver.resolvePlatformDestination(from: config))
    }

    func testInvalidPlatformSecret() throws {
        let config = DestinationConfig(app: "APP_ID", secret: "", key: "ENCRYPTION_KEY", threshold: nil)

        XCTAssertThrowsError(try resolver.resolvePlatformDestination(from: config))
    }

    func testInvalidPlatformKey() throws {
        let config = DestinationConfig(app: "APP_ID", secret: "SECRETN", key: "", threshold: nil)

        XCTAssertThrowsError(try resolver.resolvePlatformDestination(from: config))
    }

    // MARK: Helpers

    func assertCommonProperties(_ defaultDestination: BaseDestination, _ destination: BaseDestination, _ config: DestinationConfig) throws {
        // format
        XCTAssertNotEqual(defaultDestination.format, destination.format)
        XCTAssertEqual(destination.format, config.format)

        // async
        XCTAssertNotEqual(defaultDestination.asynchronously, destination.asynchronously)
        XCTAssertEqual(destination.asynchronously, config.async)

        // minLevel
        XCTAssertNotEqual(defaultDestination.minLevel, destination.minLevel)
        XCTAssertEqual(destination.minLevel, config.minLevel?.sbLevel())

        // levelString
        XCTAssertNotEqual(defaultDestination.levelString.debug, destination.levelString.debug)
        XCTAssertEqual(destination.levelString.debug, config.levelString?.debug)

        XCTAssertNotEqual(defaultDestination.levelString.error, destination.levelString.error)
        XCTAssertEqual(destination.levelString.error, config.levelString?.error)

        XCTAssertNotEqual(defaultDestination.levelString.info, destination.levelString.info)
        XCTAssertEqual(destination.levelString.info, config.levelString?.info)

        XCTAssertNotEqual(defaultDestination.levelString.verbose, destination.levelString.verbose)
        XCTAssertEqual(destination.levelString.verbose, config.levelString?.verbose)

        XCTAssertNotEqual(defaultDestination.levelString.warning, destination.levelString.warning)
        XCTAssertEqual(destination.levelString.warning, config.levelString?.warning)
    }

    func testLinuxTestSuiteIncludesAllTests() throws {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        let darwinCount = Int(thisClass.defaultTestSuite.testCaseCount)

        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }

    static let allTests = [
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
        // Console
        ("testResolveConsoleDestination", testResolveConsoleDestination),
        // File
        ("testResolveFileDestination", testResolveFileDestination),
        ("testInvalidFilePath", testInvalidFilePath),
        // SBPlatform
        ("testResolvePlatformDestination", testResolvePlatformDestination),
        ("testInvalidPlatformThreshold", testInvalidPlatformThreshold),
        ("testInvalidPlatformApp", testInvalidPlatformApp),
        ("testInvalidPlatformSecret", testInvalidPlatformSecret),
        ("testInvalidPlatformKey", testInvalidPlatformKey)
    ]
}
