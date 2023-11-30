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
  let artistFetchService = ArtistFetchService()

  @Published var searchText: String = ""
  @Published var searchIsPresented: Bool = false
  @Published var artistList: [MusicBrainzArtist] = []
  @Published var isLoading: Bool = false
  @Published var domesticArtists: [OnboardingModel] = []
  @Published var foreignArtists: [OnboardingModel] = []
  private var cancellables = Set<AnyCancellable>()

  init() {
    let searchTextPublisher = $searchText
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .removeDuplicates()
    searchTextPublisher
      .sink { [weak self] _ in
        self?.getSearchArtistList()
      }
      .store(in: &cancellables)

    if artistFetchService.allArtist.isEmpty {
      artistFetchService.fetchData { success in
          if success {
            self.domesticArtists = self.getRandomArtists(.kpop)
            self.foreignArtists = self.getRandomArtists(.pop)
          }
      }
    }
  }

  enum ArtistKind {
    case kpop
    case pop
  }

  func getRandomArtists(_ kind: ArtistKind) -> [OnboardingModel] {
    if searchIsPresented == false {
      let kpopArtists = artistFetchService.allArtist.filter { artist in
        if let tags = artist.tags, artist.country == (kind == .kpop ? "South Korea" : "") {
          if artist.url != nil && artist.url != "" {
            return tags.contains(kind == .kpop ? "K-Pop" : "Pop")
          }
        }
        return false
      }
      return Array(kpopArtists.shuffled().prefix(9))
    }
    return []
  }

  func getSearchArtistList() {
    self.isLoading = true
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
