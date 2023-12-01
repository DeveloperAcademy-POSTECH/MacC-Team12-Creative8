//
//  YoutubeService.swift
//  Core
//
//  Created by 최효원 on 11/29/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftUI
import GoogleSignIn
import GoogleAPIClientForREST

public final class YoutubeService {
  private let service = GTLRYouTubeService()
  
  public init() {
  }
  
  public func createYouTubeService(user: GIDGoogleUser) -> GTLRYouTubeService {
    let service = GTLRYouTubeService()
    service.authorizer = user.fetcherAuthorizer
    
    return service
  }
  
  public func googleSignIn(completionHandler: @escaping (Bool) -> Void) {
    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
      if error == nil {
        print("Managed to restore previous sign in!\nScopes: \(String(describing: user?.grantedScopes))")
        
        self.requestScopes(googleUser: user!) { success in
          if success == true {
            completionHandler(true)
          } else {
            completionHandler(false)
          }
        }
      } else {
        print("No previous user!\nThis is the error: \(String(describing: error?.localizedDescription))")
        _ = GIDConfiguration.init(clientID: APIKeys().googleClientID)
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, signInError in
          if signInError == nil {
            if let gUser = signInResult?.user {
              self.requestScopes(googleUser: gUser) { signInSuccess in
                signInSuccess == true ? completionHandler(true) : completionHandler(false)
              }
            }
          } else {
            print("error with signing in: \(String(describing: signInError)) ")
            self.service.authorizer = nil
            completionHandler(false)
          }
        }
      }
    }
  }
  
  func requestScopes(googleUser: GIDGoogleUser, completionHandler: @escaping (Bool) -> Void) {
    
    let grantedScopes = googleUser.grantedScopes
    if grantedScopes == nil || !grantedScopes!.contains(APIKeys().grantedScopes) {
      let additionalScopes = APIKeys().additionalScopes
      guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
      
      googleUser.addScopes(additionalScopes, presenting: presentingViewController) { result, scopeError in
        if scopeError == nil {
          
          googleUser.refreshTokensIfNeeded { user, error in
            guard error == nil else { print("refreshError :  \(String(describing: error?.localizedDescription))")
              return }
            
            let authorizer = user?.fetcherAuthorizer
            self.service.authorizer = authorizer
            completionHandler(true)
          }
          
        } else {
          completionHandler(false)
          print("Error with adding scopes: \(String(describing: scopeError?.localizedDescription))")
        }
      }
    } else {
      print("Already contains the scopes!")
      completionHandler(true)
    }
  }
  
  public func createPlaylist(service: GTLRYouTubeService, title: String, musicList: [(String, String?)]) {
    let playlist = GTLRYouTube_Playlist()
    let snippet = GTLRYouTube_PlaylistSnippet()
    snippet.title = title
    playlist.snippet = snippet
    
    let query = GTLRYouTubeQuery_PlaylistsInsert.query(withObject: playlist, part: "snippet")
    service.executeQuery(query) { (_, result, error) in
      if let error = error {
        print("Error creating playlist: \(error.localizedDescription)")
      } else if let playlist = result as? GTLRYouTube_Playlist {
        let playlistId = playlist.identifier
        self.searchAndInsert(service: service, playlistId: playlistId!, musicList: musicList)
        print("Playlist created with ID: \(playlistId ?? "Unknown")")
      }
    }
  }
  
  
  func getSearchList(service: GTLRYouTubeService, playlistId: String, title: String, artist: String, completion: @escaping () -> Void) {
    let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
    query.maxResults = 1
    query.type = "video"
    query.q = artist + " " + title
    
    service.executeQuery(query) { ticket, searchList, error in
      if error == nil {
        let searchList = searchList as? GTLRYouTube_SearchListResponse
        if (searchList?.items) != nil {
          self.insertPlaylistItem(service: service, playlistId: playlistId, videoId: searchList?.items![0].identifier?.videoId ?? "")
          completion()
          
        } else {
          print("Search list empty")
          completion()
          
        }
      } else {
        print("Youtube Search error: \(String(describing: error?.localizedDescription))")
        completion()
        
      }
    }
  }
  
  func insertPlaylistItem(service: GTLRYouTubeService, playlistId: String, videoId: String) {
    
    let playlistItem = GTLRYouTube_PlaylistItem()
    playlistItem.snippet = GTLRYouTube_PlaylistItemSnippet()
    playlistItem.snippet!.playlistId = playlistId
    
    let resourceId = GTLRYouTube_ResourceId()
    resourceId.kind = "youtube#video"
    resourceId.videoId = videoId
    
    playlistItem.snippet!.resourceId = resourceId
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
      let query = GTLRYouTubeQuery_PlaylistItemsInsert.query(withObject: playlistItem, part: "snippet")
      
      service.executeQuery(query) { (_, _, error) in
        if let error = error {
          print("Error adding video \(videoId) to playlist \(playlistId): \(error.localizedDescription)")
          
        } else {
          print("Added video \(videoId) to playlist \(playlistId)")
        }
      }
    }
  }
  
  func searchAndInsert(service: GTLRYouTubeService, playlistId: String, musicList: [(String, String?)]) {
    var currentIndex = 0
    
    func processNext() {
      guard currentIndex < musicList.count else {
        return
      }
      
      let title = musicList[currentIndex].0
      let artist = musicList[currentIndex].1 ?? ""
      getSearchList(service: service, playlistId: playlistId, title: title, artist: artist) {
        currentIndex += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
          processNext()
        }
      }
    }
    processNext()
  }
}

