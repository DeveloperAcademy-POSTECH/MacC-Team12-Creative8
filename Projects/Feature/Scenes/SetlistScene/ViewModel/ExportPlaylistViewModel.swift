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
    var status: MusicAuthorization.Status = .notDetermined
    status = MusicAuthorization.currentStatus
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
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
      self.showToastMessageAppleMusic = false
    }
  }
  
  func handleAppleMusicButtonAction() {
    if self.getMusicKitPermissionStatus() == .notDetermined {
      AppleMusicService().requestMusicAuthorization()
    } else if self.getMusicKitPermissionStatus() == .denied {
      self.showMusicSettingsAlert = true
    } else {
      CheckAppleMusicSubscription.shared.appleMusicSubscription()
      if CheckAppleMusicSubscription.shared.getCheckValue() {
        self.showAppleMusicAlert.toggle()
        self.playlistTitle = ""
      } else {
        
      }
    }
  }
  
  //MARK: YouTubeMusic
  func addToYouTubeMusic() {
    //TODO: 유튜브뮤직
  }
}
