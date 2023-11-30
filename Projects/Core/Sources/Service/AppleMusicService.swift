//
//  AppleMusicService.swift
//  Core
//
//  Created by 최효원 on 10/18/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import MusicKit
import StoreKit

public final class AppleMusicService: MusicPlaylistAddable, Sendable {
  public var id: MusicItemID = ""
  
  public init() {
  }
  
  // 플레이리스트 추가 및 음악 목록 추가
  public func addPlayList(name: String, musicList: [(String, String?)], venue: String?) {
    Task {
      // musicList를 index가 들어간 튜플로 변환
      let indexedMusicList = musicList.enumerated().map { (index, music) in
        (index, music)
      }
      // index 순서대로 정렬
      let sortedMusicList = indexedMusicList.sorted { $0.0 < $1.0 }.map { $0.1 }
      
      let newPlayList = try await MusicLibrary.shared.createPlaylist(name: String(name), description: "Seta에서 생성된 플레이리스트 입니다.", authorDisplayName: String(venue ?? ""))
      
      for music in sortedMusicList {
        // MusicCatalogSearchRequest를 비동기로 처리
        let response = try await searchMusic(title: String(music.0), singer: music.1 ?? "")
        
        if let song = response.songs.first {
          // 순차적으로 MusicLibrary에 추가
          try await MusicLibrary.shared.add(song, to: newPlayList)
        }
      }
    }
  }
  
  // MusicCatalogSearchRequest를 비동기로 처리하는 함수
  private func searchMusic(title: String, singer: String) async throws -> MusicCatalogSearchResponse {
    var request = MusicCatalogSearchRequest.init(term: "\(singer) \(title)", types: [MusicKit.Song.self])
    request.includeTopResults = true
    let response = try await request.response()
    return response
  }
  
  public func requestMusicAuthorization() {
    SKCloudServiceController.requestAuthorization { [weak self] status in
      switch status {
      case .authorized:
        print("Apple Music authorized")
      case .restricted:
        print("Apple Music authorization restricted")
      case .notDetermined:
        print("Apple Music authorization not determined")
      case .denied:
        print("Apple Music authorization denied")
      @unknown default:
        print("")
      }
    }
  }
  
}

public final class CheckAppleMusicSubscription: ObservableObject {
  @Published var check: Bool = false
  public static let shared: CheckAppleMusicSubscription = CheckAppleMusicSubscription()
  // 사용자가 애플 뮤직을 구독 중인지 확인
  public init() {
  }
  
  public func appleMusicSubscription() {
    SKCloudServiceController().requestCapabilities { (capability: SKCloudServiceCapability, err: Error?) in
      // 에러 발생시
      guard err == nil else { return }
      // 사용자가 애플 뮤직을 구독 중이라면
      if capability.contains(SKCloudServiceCapability.musicCatalogPlayback) { self.check = true }
      // 사용자가 애플 뮤직을 구독 중이지 않다면
      if capability.contains(SKCloudServiceCapability.musicCatalogSubscriptionEligible) { self.check = false }
    }
  }
  
  public func getCheckValue() -> Bool {
      return check
  }
}
