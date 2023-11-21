//
//  BottomModalView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI
import Combine
import SpotifyWebAPI

struct BottomModalView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var vm: SetlistViewModel
  @Binding var showToastMessageAppleMusic: Bool
  @Binding var showToastMessageCapture: Bool
  
  @ObservedObject var spotifyService = SpotifyService()
  @State var cancellables: Set<AnyCancellable> = []
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      
      listRowView(title: "Apple Music에 옮기기", description: nil, action: {
        AppleMusicService().requestMusicAuthorization()
        CheckAppleMusicSubscription.shared.appleMusicSubscription()
        AppleMusicService().addPlayList(name: "\(artistInfo?.name ?? "" ) @ \(setlist?.eventDate ?? "")", musicList: vm.setlistSongName, singer: artistInfo?.name ?? "", venue: setlist?.venue?.name)
        vm.showModal.toggle()
        showToastMessageAppleMusic = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          showToastMessageAppleMusic = false
        }
      })
      
      Spacer()
      
      Group {
        if !spotifyService.isAuthorized {
          listRowView(title: "Spotify 로그인", description: nil) {
            spotifyService.authorize()
          }.allowsHitTesting(!spotifyService.isRetrievingTokens)
        } else {
          listRowView(title: "Spotify에 옮기기", description: nil) {
            performPlaylistCreation()
            vm.showModal.toggle()
          }
          Button("Logout") {
            spotifyService.api.authorizationManager.deauthorize()
          }
        }
      }.onOpenURL(perform: handleURL(_:))
      
      Spacer()
      
      listRowView(
        title: "세트리스트 캡처하기",
        description: "Bugs, FLO, genie, VIBE의 유저이신가요? OCR 서비스를\n사용해 캡쳐만으로 플레이리스트를 만들어 보세요.",
        action: {
          takeSetlistToImage(vm.setlistSongKoreanName, artistInfo?.name ?? "")
          vm.showModal.toggle()
          showToastMessageCapture = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            showToastMessageCapture = false
          }
        }
      )
      
      Spacer()
    }
    .padding(.horizontal, 30)
    .background(Color.settingTextBoxWhite)
  }
  
  private func listRowView(title: String, description: String?, action: @escaping () -> Void) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: UIHeight * 0.01) {
        Text(title)
          .font(.headline)
          .foregroundStyle(Color.mainBlack)
        if let description = description {
          Text(description)
            .font(.caption)
            .foregroundStyle(Color.fontGrey2)
        }
      }
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundStyle(Color.mainBlack)
    }
    .onTapGesture {
      action()
    }
  }
  
  func handleURL(_ url: URL) {
    guard url.scheme == self.spotifyService.loginCallbackURL.scheme else {
      print("not handling URL: unexpected scheme: '\(url)'")
      return
    }
    
    print("received redirect from Spotify: '\(url)'")
    
    spotifyService.isRetrievingTokens = true
    
    spotifyService.api.authorizationManager.requestAccessAndRefreshTokens(
      redirectURIWithQuery: url,
      state: spotifyService.authorizationState
    )
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { completion in
      self.spotifyService.isRetrievingTokens = false
      
      if case .failure(let error) = completion {
        print("couldn't retrieve access and refresh tokens:\n\(error)")
        if let authError = error as? SpotifyAuthorizationError,
           authError.accessWasDenied {
        }
      }
    })
    .store(in: &cancellables)
    
    self.spotifyService.authorizationState = String.randomURLSafe(length: 128)
    
  }
  
  func performPlaylistCreation() {
    var trackUris: [String] = []
    var playlistUri: String = ""
    
    func searchTracks() -> AnyPublisher<Void, Error> {
      let artistName = artistInfo?.name
      let songList = vm.setlistSongKoreanName
      
      return Publishers.Sequence(sequence: songList)
        .flatMap(maxPublishers: .max(1)) { song -> AnyPublisher<String?, Never> in
          let query = "\(artistName ?? "") \(song)"
          print("@LOG query: \(query)")
          let categories: [IDCategory] = [.artist, .track]
          
          return spotifyService.api.search(query: query, categories: categories, limit: 1)
            .map { searchResult in
              print("@LOG searchResult \(searchResult.tracks?.items.first?.name)")
              return searchResult.tracks?.items.first?.uri
            }
            .replaceError(with: nil) // Ignore errors and replace with nil
            .eraseToAnyPublisher()
        }
        .compactMap { $0 } // Filter out nil values
        .collect()
        .map { nonDuplicateTrackUris in
          trackUris = nonDuplicateTrackUris
        }
        .eraseToAnyPublisher()
    }
    
    func createPlaylist() -> AnyPublisher<Void, Error> {
      guard let userURI: SpotifyURIConvertible = spotifyService.currentUser?.uri else {
        return Fail(error: ErrorType.userNotFound).eraseToAnyPublisher()
      }
      
      let playlistDetails = PlaylistDetails(name: "\(artistInfo?.name ?? "" ) @ \(setlist?.eventDate ?? "")",
                                            isPublic: false,
                                            isCollaborative: false,
                                            description: nil)
      
      return spotifyService.api.createPlaylist(for: userURI, playlistDetails)
        .map { playlist in
          print("Playlist created: \(playlist)")
          playlistUri = playlist.uri
        }
        .eraseToAnyPublisher()
    }
    
    func addTracks() -> AnyPublisher<Void, Error> {
      guard !trackUris.isEmpty else {
        return Fail(error: ErrorType.noTracksFound).eraseToAnyPublisher()
      }
      
      let uris: [SpotifyURIConvertible] = trackUris
      
      return spotifyService.api.addToPlaylist(playlistUri, uris: uris)
        .map { result in
          print("Items added successfully. Result: \(result)")
        }
        .eraseToAnyPublisher()
    }
    
    // Chain the functions sequentially
    searchTracks()
      .flatMap { _ in createPlaylist() }
      .flatMap { _ in addTracks() }
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("Playlist creation completed successfully.")
        case .failure(let error):
          print("Error: \(error)")
        }
      }, receiveValue: {})
      .store(in: &cancellables)
  }
  
  enum ErrorType: Error {
    case trackNotFound
    case userNotFound
    case noTracksFound
  }
}
