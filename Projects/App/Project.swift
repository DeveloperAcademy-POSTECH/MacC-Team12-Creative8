//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Seta",
  platform: .iOS,
  product: .app,
  packages: [
    .CoreXLSX,
    .Firebase
  ],
  dependencies: [
    .Projcet.Feature,
    .SPM.CoreXLSX,
    .SPM.Firebase
  ],
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  infoPlist: .extendingDefault(with: [
    "CFBundleShortVersionString": "1.0.1",
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "ENABLE_TESTS": .boolean(true)
  ])
)
