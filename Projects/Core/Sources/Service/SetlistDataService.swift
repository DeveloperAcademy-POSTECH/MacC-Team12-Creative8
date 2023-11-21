//
//  DataService.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

public final class SetlistDataService {
  public init() {
    
  }
  
  private func APIRequest<T: Codable>(url: URL, httpMethod: String, headers: [String: String], completion: @escaping (T?) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    
    for (headerField, headerValue) in headers {
      request.setValue(headerValue, forHTTPHeaderField: headerField)
    }
    
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: request) { data, _, error in
      if let error = error {
        print(error)
        completion(nil)
      } else if let JSONdata = data {
        let decoder = JSONDecoder()
        do {
          let decodedData = try decoder.decode(T.self, from: JSONdata)
          completion(decodedData)
        } catch let error {
          print(error)
          completion(nil)
        }
      } else {
        completion(nil)
      }
    }
    task.resume()
  }
  
  public func fetchArtistFromMusicBrainz(artistMbid: String, completion: @escaping (ArtistListModel?) -> Void) {
    if let url = URL(string: "https://musicbrainz.org/ws/2/artist/?query=mbid:\(artistMbid)&fmt=json") {
      let headers = ["Authorization": APIKeys().musicBrainz]
      APIRequest(url: url, httpMethod: "GET", headers: headers, completion: completion)
    } else {
      completion(nil)
    }
  }
  
  public func searchArtistsFromMusicBrainz(artistName: String, completion: @escaping (ArtistListModel?) -> Void) {
    if let url = URL(string: "https://musicbrainz.org/ws/2/artist?query=\(artistName)&fmt=json") {
      let headers = ["Authorization": APIKeys().musicBrainz]
      APIRequest(url: url, httpMethod: "GET", headers: headers, completion: completion)
    } else {
      completion(nil)
    }
  }

  public func fetchOneSetlistFromSetlistFM(setlistId: String, completion: @escaping (Setlist?) -> Void) {
      if let url = URL(string: "https://api.setlist.fm/rest/1.0/setlist/\(setlistId)") {
        let headers = [
          "x-api-key": APIKeys().setlistFM,
          "Accept": "application/json",
          "Accept-Language": "en"
        ]
        APIRequest(url: url, httpMethod: "GET", headers: headers, completion: completion)
      } else {
        completion(nil)
      }
    }

  public func fetchSetlistsFromSetlistFM(artistMbid: String, page: Int, completion: @escaping (SetlistListModel?) -> Void) {
    if let url = URL(string: "https://api.setlist.fm/rest/1.0/search/setlists?artistMbid=\(artistMbid)&p=\(page)") {
      let headers = [
        "x-api-key": APIKeys().setlistFM,
        "Accept": "application/json",
        "Accept-Language": "en"
      ]
      APIRequest(url: url, httpMethod: "GET", headers: headers, completion: completion)
    } else {
      completion(nil)
    }
  }
  
  public func searchArtistFromGenius(artistName: String, completion: @escaping (GeniusArtistsModel?) -> Void) {
    if let url = URL(string: "https://api.genius.com/search?q=\(artistName)") {
      print("request url: \(url)")
      let headers = ["Authorization": APIKeys().genius]
      APIRequest(url: url, httpMethod: "GET", headers: headers, completion: completion)
    } else {
      completion(nil)
    }
  }
  
  public func fetchSongsFromGenius(artistId: Int, page: Int, completion: @escaping (GeniusSongsModel?) -> Void) {
    if let url = URL(string: "https://api.genius.com/artists/\(artistId)/songs?page=\(page)&per_page=50") {
      let headers = ["Authorization": APIKeys().genius]
      APIRequest(url: url, httpMethod: "GET", headers: headers, completion: completion)
    } else {
      completion(nil)
    }
  }
  
}
