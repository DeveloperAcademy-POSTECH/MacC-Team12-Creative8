//
//  ExportPlaylistViewModel.swift
//  Feature
//
//  Created by 장수민 on 11/21/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import Photos
import Core
import MusicKit
import GoogleSignIn

final class ExportPlaylistViewModel: ObservableObject {
  @Published var playlistTitle: String = ""
  @Published var showYouTubeAlert: Bool = false
  @Published var showAppleMusicAlert: Bool = false
  @Published var showToastMessageAppleMusic: Bool = false
  @Published var showToastMessageCapture = false
  @Published var showLibrarySettingsAlert = false
  @Published var showMusicSettingsAlert = false
  
  
  //MARK: Photo
  func checkPhotoPermission() -> Bool {
    var status: PHAuthorizationStatus = .notDetermined
    
    if #available(iOS 14, *) {
      status = PHPhotoLibrary.authorizationStatus()
    } else {
      status = PHPhotoLibrary.authorizationStatus()
    }
    return status == .denied || status == .notDetermined
    
  }
  
  func requestPhotoLibraryPermission() {
    PHPhotoLibrary.requestAuthorization { status in
      switch status {
      case .authorized:
        // 권한이 허용된 경우
        print("Photo library access granted")
      case .denied, .restricted:
        // 권한이 거부되거나 제한된 경우
        print("Photo library access denied")
      case .notDetermined:
        // 권한이 아직 결정되지 않은 경우
        print("Photo library access not determined")
      case .limited:
        print("Photo library access limited")
      @unknown default:
        print("omg")
      }
    }
  }
  
  func getPhotoLibraryPermissionStatus() -> PHAuthorizationStatus {
    let status = PHPhotoLibrary.authorizationStatus()
    return status
  }
  
  func handlePhotoExportButtonAction() {
    if self.getPhotoLibraryPermissionStatus() == .notDetermined {
      self.requestPhotoLibraryPermission()
    } else if self.getPhotoLibraryPermissionStatus() == .denied {
      self.showLibrarySettingsAlert = true
    } else {
      self.showToastMessageCapture = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        self.showToastMessageCapture = false
      }
    }
  }
  
  //MARK: AppleMusic
  func getMusicKitPermissionStatus() -> MusicAuthorization.Status {
    let status: MusicAuthorization.Status = MusicAuthorization.currentStatus
    return status
  }
  
  func checkMusicKitPermission() -> Bool {
    var status = MusicAuthorization.currentStatus
    return status == .denied || status == .notDetermined
  }
  
  func addToAppleMusic(musicList: [(String, String?)], setlist: Setlist?) {
    AppleMusicService().addPlayList(
      name: self.playlistTitle,
      musicList: musicList,
      venue: setlist?.venue?.name
    )
    self.showAppleMusicAlert = false
    self.showToastMessageAppleMusic = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      self.showToastMessageAppleMusic = false
      self.openMusicApp(url: MusicURL.AppleMusic)
    }
  }
  
  func handleAppleMusicButtonAction() {
    if self.getMusicKitPermissionStatus() == .notDetermined {
      AppleMusicService().requestMusicAuthorization()
    } else if self.getMusicKitPermissionStatus() == .denied {
      self.showMusicSettingsAlert = true
    } else {
      CheckAppleMusicSubscription.shared.appleMusicSubscription()
      self.showAppleMusicAlert = true
      self.playlistTitle = ""
    }
  }
  
  //MARK: YouTubeMusic
  func addToYouTubeMusic(musicList: [(String, String?)]) {
    YoutubeService().googleSignIn() { success in
      let user = GIDSignIn.sharedInstance.currentUser
      if let user = user {
        let youtubeService = YoutubeService().createYouTubeService(user: user)
        YoutubeService().createPlaylist(
          service: youtubeService,
          title: self.playlistTitle,
          musicList: musicList
        )
        self.showYouTubeAlert = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
          self.openMusicApp(url: MusicURL.Youtube)
        }
      }
    }
  }
  
  func openMusicApp(url: String) {
    let url = URL(string: url)!
    if UIApplication.shared.canOpenURL(url) {
      if #available(iOS 16.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }
  
  public enum MusicURL {
    public static let AppleMusic = "https://music.apple.com/"
    public static let Youtube = "https://www.youtube.com/"
    public static let Spotify = "https://open.spotify.com/"
  }
}
