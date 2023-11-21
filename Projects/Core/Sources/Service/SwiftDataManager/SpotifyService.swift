//
//  SpotifyService.swift
//  Core
//
//  Created by 고혜지 on 11/21/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SpotifyWebAPI
import KeychainAccess

public class SpotifyService: ObservableObject {
  
  private static let clientId: String = "f782b60e9c154ce7b5e8619f44fffa83"
  private static let clientSecret: String = "162c994ab7904779be36df3a829c94d1"
  
//  private static let clientId: String = {
//    if let clientId = ProcessInfo.processInfo
//      .environment["CLIENT_ID"] {
//      return clientId
//    }
//    fatalError("Could not find 'CLIENT_ID' in environment variables")
//  }()
//  
//  private static let clientSecret: String = {
//    if let clientSecret = ProcessInfo.processInfo
//      .environment["CLIENT_SECRET"] {
//      return clientSecret
//    }
//    fatalError("Could not find 'CLIENT_SECRET' in environment variables")
//  }()
  
  public let authorizationManagerKey = "authorizationManager"
  public let loginCallbackURL = URL(string: "seta://login-callback")!
  public var authorizationState = String.randomURLSafe(length: 128)
  
  @Published public var isAuthorized = false
  @Published public var isRetrievingTokens = false
  @Published public var currentUser: SpotifyUser? = nil
  
  public let keychain = Keychain(service: "com.creative8.seta.Seta")
  
  public let api = SpotifyAPI(
    authorizationManager: AuthorizationCodeFlowManager(
      clientId: SpotifyService.clientId,
      clientSecret: SpotifyService.clientSecret
    )
  )
  
  public var cancellables: Set<AnyCancellable> = []
  
  public init() {
    self.api.apiRequestLogger.logLevel = .trace
    
    self.api.authorizationManagerDidChange
      .receive(on: RunLoop.main)
      .sink(receiveValue: authorizationManagerDidChange)
      .store(in: &cancellables)
    
    self.api.authorizationManagerDidDeauthorize
      .receive(on: RunLoop.main)
      .sink(receiveValue: authorizationManagerDidDeauthorize)
      .store(in: &cancellables)
    
    
    if let authManagerData = keychain[data: self.authorizationManagerKey] {
      
      do {
        // Try to decode the data.
        let authorizationManager = try JSONDecoder().decode(
          AuthorizationCodeFlowManager.self,
          from: authManagerData
        )
        print("found authorization information in keychain")
        
        self.api.authorizationManager = authorizationManager
        
      } catch {
        print("could not decode authorizationManager from data:\n\(error)")
      }
    }
    else {
      print("did NOT find authorization information in keychain")
    }
    
  }
  
  public func authorize() {
    
    let url = self.api.authorizationManager.makeAuthorizationURL(
      redirectURI: self.loginCallbackURL,
      showDialog: true,
      state: self.authorizationState,
      scopes: [
        .playlistModifyPrivate,
        .playlistModifyPublic,
      ]
    )!
    UIApplication.shared.open(url)
    
  }
  
  public func authorizationManagerDidChange() {
    
    self.isAuthorized = self.api.authorizationManager.isAuthorized()
    
    print(
      "Spotify.authorizationManagerDidChange: isAuthorized:",
      self.isAuthorized
    )
    
    self.retrieveCurrentUser()
    
    do {
      let authManagerData = try JSONEncoder().encode(
        self.api.authorizationManager
      )
      
      self.keychain[data: self.authorizationManagerKey] = authManagerData
      print("did save authorization manager to keychain")
      
    } catch {
      print(
        "couldn't encode authorizationManager for storage " +
        "in keychain:\n\(error)"
      )
    }
    
  }
  
  public func authorizationManagerDidDeauthorize() {
    
    self.isAuthorized = false
    
    self.currentUser = nil
    
    do {
      try self.keychain.remove(self.authorizationManagerKey)
      print("did remove authorization manager from keychain")
      
    } catch {
      print(
        "couldn't remove authorization manager " +
        "from keychain: \(error)"
      )
    }
  }
  
  public func retrieveCurrentUser(onlyIfNil: Bool = true) {
    
    if onlyIfNil && self.currentUser != nil {
      return
    }
    
    guard self.isAuthorized else { return }
    
    self.api.currentUserProfile()
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            print("couldn't retrieve current user: \(error)")
          }
        },
        receiveValue: { user in
          self.currentUser = user
        }
      )
      .store(in: &cancellables)
    
  }
  
}
