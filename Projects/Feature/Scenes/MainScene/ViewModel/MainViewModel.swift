//
//  MainViewModel.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation
import SwiftUI
import Core

final class MainViewModel: ObservableObject {
  let dataService = SetlistDataService()
  let koreanConverter = KoreanConverter()
  
  @Published var selectedIndex: Int?
  @Published var scrollToIndex: Int?
  @Published var isTapped: Bool = false
  @Published var isLoading: Bool = false
  var setlists = [[Setlist?]?](repeating: nil, count: 100) // MARK: 나중에 꼭 수정하기!
  
  func replaceFirstSpaceWithNewline(_ input: String) -> String {
    guard let range = input.rangeOfCharacter(from: .whitespaces) else {
      return input
    }
    return input.replacingCharacters(in: range, with: "\n")
  }
  
  func getSetlistsFromSetlistFM(artistMbid: String, idx: Int) {
    self.isLoading = true
    dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: 1) { result in
      if let result = result {
        DispatchQueue.main.async {
          self.setlists[idx] = result.setlist
          self.isLoading = false
        }
      } else {
        self.isLoading = false
        print("Failed to fetch setlist data.")
      }
    }
  }
  
  func getFormattedDateAndMonth(date: String) -> String? {
    let inputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd-MM-yyyy"
      return formatter
    }()
    
    let outputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM.dd"
      return formatter
    }()
    
    if let inputDate = inputDateFormatter.date(from: date) {
      return outputDateFormatter.string(from: inputDate)
    } else {
      return nil
    }
  }
  
  func getFormattedYear(date: String) -> String? {
    let inputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd-MM-yyyy"
      return formatter
    }()
    
    let outputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "YYYY"
      return formatter
    }()
    
    if let inputDate = inputDateFormatter.date(from: date) {
      return outputDateFormatter.string(from: inputDate)
    } else {
      return nil
    }
  }
}

public enum ButtonType: Int, CaseIterable, Identifiable {
  public var id: Int { self.rawValue }
  case automatic, light, dark
  
  public var icon: String {
    switch self {
    case .automatic:
      return "circle.lefthalf.filled"
    case .light:
      return "sun.max.fill"
    case .dark:
      return "moon.stars.fill"
    }
  }
  
  public var name: String {
    switch self {
    case .light: return "라이트"
    case .dark: return "다크"
    case .automatic: return "자동"
    }
  }
  
  public func getColorScheme() -> ColorScheme? {
    switch self {
    case .automatic: return nil
    case .light: return .light
    case .dark: return .dark
    }
  }
}
