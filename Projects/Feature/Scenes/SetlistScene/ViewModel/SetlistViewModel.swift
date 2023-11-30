//
//  SetlistViewModel.swift
//  Feature
//
//  Created by 고혜지 on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import Core

final class SetlistViewModel: ObservableObject {
  @Published var isBookmarked: Bool
  @Published var showModal: Bool
  @Published var isLoading: Bool
  
  let koreanConverter = KoreanConverter()
  let dataService = SetlistDataService()
  let artistDataManager = ArtistDataManager()
  let dataManager = SwiftDataManager()
  
  // [(songTitle, artistName)]
  var setlistSongName: [(String, String?)] = []
  var setlistSongKoreanName: [(String, String?)] = []
  
  init() {
    self.isBookmarked = false
    self.showModal = false
    self.isLoading = false
  }
  
  func isEmptySetlist(_ setlist: Setlist) -> Bool {
    return setlist.sets?.setsSet?.isEmpty == true
  }
  
  func getFormattedDateFromString(date: String, format: String) -> String? {
    let inputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd-MM-yyyy"
      return formatter
    }()
    
    let outputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = format
      formatter.locale = Locale(identifier: "en_US")
      return formatter
    }()
    
    if let inputDate = inputDateFormatter.date(from: date) {
      return outputDateFormatter.string(from: inputDate)
    } else {
      return nil
    }
  }
  
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
  func  allDateFormatter(inputDate: String) -> String? {
    guard let languageCode = Locale.current.language.languageCode?.identifier else { return "" }

      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd-MM-yyyy"

      // 입력된 날짜 문자열을 "dd-MM-yyyy" 형식으로 변환
      guard let convertedDate = dateFormatter.date(from: inputDate) else {
          return ""
      }
      // TODO: 날짜 형식 어떻게 보여줄지? 정하기
      dateFormatter.dateFormat = (languageCode == "ko") ? "yyyy년 MM월 dd일" : "MMMM dd, yyyy"

      // 변환된 날짜를 설정한 형식으로 문자열로 반환
      return dateFormatter.string(from: convertedDate)
  }

  func convertDateStringToDate(_ dateString: String, format: String = "dd-MM-yyyy") -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Optional: Specify the locale
    
    if let date = dateFormatter.date(from: dateString) {
      return date
    } else {
      return nil // 날짜 형식이 맞지 않을 경우 nil 반환
    }
  }

  func createArrayForExportPlaylist(setlist: Setlist?, songList: [Titles], artistName: String?) {
    
    setlistSongName = []
    setlistSongKoreanName = []
    
    for session in setlist?.sets?.setsSet ?? [] {
      for song in session.song ?? [] {
        if let title = song.name {
          var name: String?
          if let cover = song.cover?.name { // 커버곡이면
            name = cover
          } else { // 커버곡이 아니면
            name = artistName
          }
          
          // 영문 배열에 추가
          self.setlistSongName.append((title, name))
          
          // 한글 배열에 추가
          let tmp = self.koreanConverter.findKoreanTitle(title: title, songList: songList) ?? title
          self.setlistSongKoreanName.append((tmp, name))
          
        }
        
      }
    }
    
  }
}
