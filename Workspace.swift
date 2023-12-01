//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(name: "Setlist",
                          projects: Module.allCases.map(\.path))
