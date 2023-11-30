//
//  OnboardingViewModel.swift
//  Feature
//
//  Created by 예슬 on 2023/10/22.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Foundation
import CoreXLSX
import Core

public final class OnboardingViewModel: ObservableObject {
  @Published var selectedArtist: [OnboardingModel] = []
  @Published var selectedGenere: OnboardingFilterType = .all
  @Published var isShowToastBar = false
  @Published var artistFetchError = false
  @ObservedObject var dataManager = SwiftDataManager()
  @AppStorage("isOnboarding") var isOnboarding: Bool?

  init() {
  }

  func findFilterTagName(_ tag: OnboardingFilterType) -> String {
    switch(tag) {
    case .all: return ""
    case .kpop: return "K-Pop"
    case .pop: return "Pop"
    case .hiphop: return "Hip-Hop"
    case .rnb: return "R&B"
    case .rock: return "Rock"
    case .metal: return "Metal"
    case .elctronic: return "Electronic"
    case .folk: return "Country/Folk"
    case .jpop: return "J-Pop"
    }
  }
}

// array nil 분기 처리
extension Array {
  subscript (safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
