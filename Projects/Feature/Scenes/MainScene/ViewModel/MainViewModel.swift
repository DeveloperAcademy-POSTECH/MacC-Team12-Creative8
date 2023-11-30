//
//  MainViewModel.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation
import SwiftUI
import Core
import Combine

final class MainViewModel: ObservableObject {
  let dataService = SetlistDataService()
  let koreanConverter = KoreanConverter()
  
  @Published var selectedIndex: Int?
  @Published var scrollToIndex: Int?
  @Published var isTapped: Bool = false
  @Published var isLoading: Bool = false
  var setlists = [[Setlist?]?](repeating: nil, count: 100) // MARK: 나중에 꼭 수정하기!
  
  func replaceFirstSpaceWithNewline(_ input: String) -> String {
    if input == "Noel Gallagher’s High Flying Birds" {
      return "Noel Gallagher’s\nHigh Flying Birds"
    } else {
      guard let range = input.rangeOfCharacter(from: .whitespaces) else {
        return input
      }
      return input.replacingCharacters(in: range, with: "\n")
    }
  }
  
  func getSetlistsFromSetlistFM(artistMbid: String, idx: Int) {
    self.isLoading = true
    dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: 1) { result in
      if let result = result {
        let filteredSetlists = result.setlist?.filter {
          $0.venue?.name != "SBS Inkigayo"
          && $0.venue?.name != "M Countdown"
          && $0.venue?.name != "Show! Music Core"
          && $0.venue?.name != "KBS Music Bank"
          && $0.venue?.name != "Show Champion"
          && $0.venue?.name != "The Show"
          && $0.venue?.name != "KBS Cool FM"
        } ?? []
        DispatchQueue.main.async {
          self.setlists[idx] = filteredSetlists
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
  
  // MARK: 현지화
  func dayAndMonthDateFormatter(inputDate: String) -> String? {
    guard let languageCode = Locale.current.language.languageCode?.identifier else { return "" }

      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd-MM-yyyy"

      // 입력된 날짜 문자열을 "dd-MM-yyyy" 형식으로 변환
      guard let convertedDate = dateFormatter.date(from: inputDate) else {
          return ""
      }

      dateFormatter.dateFormat = (languageCode == "ko") ? "MM.dd" : "dd.MM"

      // 변환된 날짜를 설정한 형식으로 문자열로 반환
      return dateFormatter.string(from: convertedDate)
  }
  func isKorean() -> Bool {
    guard let languageCode = Locale.current.language.languageCode?.identifier else { return false }
      return languageCode == "ko"
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
