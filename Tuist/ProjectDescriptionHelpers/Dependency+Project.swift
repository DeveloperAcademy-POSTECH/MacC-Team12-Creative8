//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import ProjectDescription

extension TargetDependency {
    public enum Projcet {}
}

public extension TargetDependency.Projcet {
    static let Feature = TargetDependency.project(target: "Feature", path: .relativeToRoot("Projects/Feature"))
}

public enum Module {
  case app
  case core
  case feature
  case ui
}

extension Module {
  public var name: String {
    switch self {
    case .app:
      return "App"
    case .core:
      return "Core"
    case .feature:
      return "Feature"
    case .ui:
      return "UI"
    }
  }
  
  public var path: ProjectDescription.Path {
    return .relativeToRoot("Projects/" + self.name)
  }
  
  public var project: TargetDependency {
    return .project(target: self.name, path: self.path)
  }
}

extension Module: CaseIterable { }
