//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Feature",
  product: .framework,
  dependencies: [
    .project(target: "Core", path: .relativeToRoot("Projects/Core")),
    .project(target: "UI", path: .relativeToRoot("Projects/UI")),
    .SPM.CoreXLSX
  ],
  sources: ["Scenes/**"]
)
