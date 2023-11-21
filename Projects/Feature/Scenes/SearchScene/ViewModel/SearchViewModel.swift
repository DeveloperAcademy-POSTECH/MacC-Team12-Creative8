//
//  SearchViewModel.swift
//  Feature
//
//  Created by 최효원 on 10/7/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import Core
import Combine

final class SearchViewModel: ObservableObject {
  let dataService = SetlistDataService()
  let artistDataManager = ArtistDataManager()
  let koreanConverter = KoreanConverter()
  
  @Published var searchText: String = ""
  @Published var searchIsPresented: Bool = false
  @Published var artistList: [MusicBrainzArtist] = []
  @Published var isLoading: Bool = false
  @Published var koreanRandomArtist: [OnboardingModel] = []
  @Published var foreignRandomArtist: [OnboardingModel] = []
  @Published var koreanArtistInfo: [ArtistInfo?] = []
  @Published var foreignArtistInfo: [ArtistInfo?] = []
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    // Combine Publisher for searchText
    let searchTextPublisher = $searchText
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .removeDuplicates()
    
    // Subscribe to searchTextPublisher and call getArtistList()
    searchTextPublisher
      .sink { [weak self] searchText in
        self?.getSearchArtistList()
      }
      .store(in: &cancellables)
  }
  
  func getRandomArtist(artists: [OnboardingModel]) -> [OnboardingModel] {
      let shuffledArtists = artists.shuffled() // 아티스트를 랜덤으로 섞음
      let selectedArtists = Array(shuffledArtists.prefix(9)) // 처음부터 9개 선택

      return selectedArtists
  }

  func getArtistList(artistModel: [OnboardingModel], viewModel: OnboardingViewModel) {
      var foreignArtists: [OnboardingModel] = []
      var koreanArtists: [OnboardingModel] = []

      for index in artistModel.indices {
          if artistModel[index].filter == "해외가수" {
              foreignArtists.append(artistModel[index])
          } else {
              koreanArtists.append(artistModel[index])
          }
      }

      self.foreignRandomArtist = getRandomArtist(artists: foreignArtists)
      self.koreanRandomArtist = getRandomArtist(artists: koreanArtists)
    
  }
  
  func updateArtistInfo() {
    for index in 0..<foreignRandomArtist.count {
      self.getArtistInfo(artistName: foreignRandomArtist[index].name, artistMbid: foreignRandomArtist[index].mbid) { result in
        if let result = result {
          self.foreignArtistInfo.append(result)

        }
      }
    }

    for index in 0..<koreanRandomArtist.count {
      self.getArtistInfo(artistName: koreanRandomArtist[index].name, artistMbid: koreanRandomArtist[index].mbid) { result in
        if let result = result {
          self.koreanArtistInfo.append(result)
        }
      }
    }
  }
  
  public func getArtistInfo(artistName: String, artistMbid: String, completion: @escaping (ArtistInfo?) -> Void) {
    var artistInfo: ArtistInfo?
    
    dataService.searchArtistFromGenius(artistName: artistName) { result in
      if let result = result {
        DispatchQueue.main.async {
          artistInfo = self.artistDataManager.findOnboardingArtistImage(artistName: artistName, artistAlias: "", artistMbid: artistMbid, hits: result.response?.hits ?? [])
          completion(artistInfo)
        }
      } else {
        completion(nil)
      }
    }
  }

  func getSearchArtistList() {
    self.isLoading = true
    
    // Fetch artist list and update isLoading and artistList when completed
    Future<[MusicBrainzArtist], Error> { promise in
      self.dataService.searchArtistsFromMusicBrainz(artistName: self.searchText) { result in
        if let result = result {
          promise(.success(result.artists ?? []))
        } else {
          promise(.failure(NSError(domain: "YourDomain", code: 1, userInfo: nil)))
        }
      }
    }
    .receive(on: DispatchQueue.main)
    .sink { completion in
      switch completion {
      case .finished:
        self.isLoading = false
      case .failure(let error):
        print("Failed to fetch musicbrainz data: \(error)")
      }
    } receiveValue: { artists in
      self.artistList = artists
    }
    .store(in: &cancellables)
  }
}

enum ScrollID: String {
  case top
  case searchBar
}
