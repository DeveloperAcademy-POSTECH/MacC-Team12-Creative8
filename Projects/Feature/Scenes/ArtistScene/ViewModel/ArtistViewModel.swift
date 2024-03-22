//
//  ArtistViewModel.swift
//  Feature
//
//  Created by 고혜지 on 10/21/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import Core
import SwiftUI

class ArtistViewModel: ObservableObject {
  let dataService = SetlistDataService()
  let koreanConverter = KoreanConverter()
  let artistDataManager = ArtistDataManager()
  let swiftDataManager = SwiftDataManager()
  let archivingViewModel = ArchivingViewModel.shared
  
  var artistInfo: ArtistInfo = ArtistInfo(name: "", mbid: "")
  var setlists: [Setlist]?
  var page: Int = 1
  var totalPage: Int = 0
  
  @Published var isLikedArtist: Bool = false
  @Published var isLoadingArtistInfo: Bool = false
  @Published var isLoadingSetlist: Bool = false
  @Published var isLoadingNextPage: Bool = false
  
  func getArtistInfoFromGenius(artistName: String, artistAlias: String?, artistMbid: String) {
    self.isLoadingArtistInfo = true
    artistDataManager.getArtistInfo(artistInfo: ArtistInfo(name: artistName, alias: artistAlias, mbid: artistMbid)) { result in
      if let result = result {
        DispatchQueue.main.async {
          self.artistInfo = result
          self.isLoadingArtistInfo = false
        }
      } else {
        print("Failed to fetch artist info. 1")
        self.artistDataManager.getArtistInfo(artistInfo: ArtistInfo(name: artistAlias ?? "", alias: artistName, mbid: artistMbid)) { result in
          if let result = result {
            DispatchQueue.main.async {
              self.artistInfo = result
              self.isLoadingArtistInfo = false
            }
          } else {
            self.artistInfo = ArtistInfo(name: artistName, alias: artistAlias, mbid: artistMbid)
            self.isLoadingArtistInfo = false
            print("Failed to fetch artist info. 2")
          }
        }
      }
    }
  }
  
  func getSetlistsFromSetlistFM(artistMbid: String) {
    if self.setlists == nil {
      self.isLoadingSetlist = true
      dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: page) { result in
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
            self.setlists = filteredSetlists
            self.totalPage = Int((result.total ?? 1) / (result.itemsPerPage ?? 1) + 1)
            self.isLoadingSetlist = false
          }
        } else {
          self.isLoadingSetlist = false
          print("Failed to fetch setlist data.")
        }
      }
    }
  }
  
  func fetchNextPage(artistMbid: String) {
    page += 1
    self.isLoadingNextPage = true
    dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: page) { result in
      if let result = result {
        let filteredSetlists = result.setlist?.filter { $0.venue?.name != "SBS Inkigayo"
          && $0.venue?.name != "M Countdown"
          && $0.venue?.name != "Show! Music Core"
          && $0.venue?.name != "KBS Music Bank"
          && $0.venue?.name != "Show Champion"
          && $0.venue?.name != "The Show"
          && $0.venue?.name != "KBS Cool FM"
        } ?? []
        DispatchQueue.main.async {
          self.setlists?.append(contentsOf: filteredSetlists )
          self.isLoadingNextPage = false
        }
      } else {
        self.isLoadingNextPage = false
        print("Failed to fetch setlist data.")
      }
    }
  }
  
  func getFormattedDate(date: String, format: String) -> String? {
    let inputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd-MM-yyyy"
      return formatter
    }()
    
    let outputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = format
      return formatter
    }()
    
    if let inputDate = inputDateFormatter.date(from: date) {
      return outputDateFormatter.string(from: inputDate)
    } else {
      return nil
    }
  }
  
  func getFormattedDate(date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
  }
  
  func isEmptySetlist(_ setlist: Setlist) -> Bool {
    return setlist.sets?.setsSet?.isEmpty == true
  }
  
  func isKorean() -> Bool {
    guard let languageCode = Locale.current.language.languageCode?.identifier else { return false }
      return languageCode == "ko"
  }
}
