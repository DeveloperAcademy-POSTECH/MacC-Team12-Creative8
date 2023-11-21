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
  
  private let artistDataManager = ArtistDataManager()
  private let dataService = SetlistDataService()
  private var fileName: String
  private var fileType: String
  private var filePath: String?
  private var page: Int = 1
  private var totalPage: Int = 0
  
  var setlists: [Setlist]?
  var artistInfo: ArtistInfo?
  
  @Published var allArtist: [OnboardingModel] = []
  @Published var filteredArtist: [OnboardingModel] = []
  @Published var selectedArtist: [OnboardingModel] = []
  @Published var selectedGenere: OnboardingFilterType = .all
  @Published var isShowToastBar = false
  @Published var artistSelectedCount = 0
  
  @ObservedObject var dataManager = SwiftDataManager()
  @AppStorage("isOnboarding") var isOnboarding: Bool?
  
  init(fileName: String, fileType: String, filePath: String?) {
    self.fileName = fileName
    self.fileType = fileType
    self.filePath = Bundle.main.path(forResource: fileName, ofType: fileType)
  }
  
  convenience init() {
    self.init(fileName: "onboardingArtist", fileType: "xlsx", filePath: nil)
  }
  
  func readXslx() {
    if let fpath = self.filePath {
      guard let file = XLSXFile(filepath: fpath) else {
        fatalError("XLSX file at \(String(describing: self.filePath)) is corrupted or does not exist")
      }
      
      do {
        for wbk in try file.parseWorkbooks() {
          for (_, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
            let worksheet = try file.parseWorksheet(at: path)
            if let sharedString = try file.parseSharedStrings() {
              allArtist = (worksheet.data?.rows.compactMap { row -> OnboardingModel? in
                guard let name = row.cells[safe: 0]?.stringValue(sharedString), !name.isEmpty,
                      let mbid = row.cells[safe: 1]?.stringValue(sharedString),
                      let geniusString = row.cells[safe: 2]?.stringValue(sharedString),
                      let genius = Int(geniusString),
                      let filter = row.cells[safe: 3]?.stringValue(sharedString) else {
                  return nil
                }
                return OnboardingModel(name: name, genius: genius, mbid: mbid, filter: filter)
              })!
            }
          }
        }
      } catch {
        print(error)
      }
      
    }
  }
  
  func artistSelectionAction(at index: Int) {
    let selectedModel = filteredArtist[index]
    
    if let existingIndex = selectedArtist.firstIndex(where: { $0.id == selectedModel.id }) {
      // If the model is already selected, remove it
      selectedArtist.remove(at: existingIndex)
      artistSelectedCount -= 1
    } else {
      // If the model is not selected, add it
      selectedArtist.append(selectedModel)
      artistSelectedCount += 1
    }
    
  }
  
  func getFilteredModels() -> [OnboardingModel] {
    return allArtist.filter { $0.filter == selectedGenere.rawValue }
  }
  
  func updateFilteredModels() {
    if selectedGenere == .all {
      filteredArtist = allArtist
    } else {
      filteredArtist = getFilteredModels()
    }
  }
  
  public func getArtistInfo(artistName: String, artistMbid: String, completion: @escaping (ArtistInfo?) -> Void) {
    dataService.searchArtistFromGenius(artistName: artistName) { result in
      if let result = result {
        DispatchQueue.main.async {
          self.artistInfo = self.artistDataManager.findOnboardingArtistImage(artistName: artistName, artistAlias: "", artistMbid: artistMbid, hits: result.response?.hits ?? [])
          completion(self.artistInfo)

        }
      } else {
        completion(nil)
      }
    }
  }
  
  func getSetlistFromSetlistFM(artistMbid: String, index: Int) {
    if self.setlists == nil {
      dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: page) { result in
        if let result = result {
          DispatchQueue.main.async {
            self.setlists = result.setlist
            self.totalPage = Int((result.total ?? 1) / (result.itemsPerPage ?? 1) + 1)
            
          }
        }
      }
    }
  }
}

// array nil 분기 처리
extension Array {
  subscript (safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
