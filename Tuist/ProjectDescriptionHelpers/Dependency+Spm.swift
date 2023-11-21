//
//  Dependency+Spm.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import ProjectDescription

public extension TargetDependency {
  enum SPM {}
}

public extension Package {
  static let CoreXLSX = Package.remote(url: "https://github.com/CoreOffice/CoreXLSX.git", requirement: .upToNextMajor(from: "0.14.2"))
  static let Firebase = Package.remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "10.17.0"))
  static let SpotifyAPI = Package.remote(url: "https://github.com/Peter-Schorn/SpotifyAPI.git", requirement: .upToNextMajor(from: "2.2.4"))
  static let KeychainAccess = Package.remote(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", requirement: .upToNextMajor(from: "4.2.2"))
}

public extension TargetDependency.SPM {
  static let CoreXLSX = TargetDependency.package(product: "CoreXLSX")
  static let Firebase = TargetDependency.package(product: "FirebaseAnalytics")
  static let SpotifyAPI = TargetDependency.package(product: "SpotifyAPI")
  static let KeychainAccess = TargetDependency.package(product: "KeychainAccess")
}
