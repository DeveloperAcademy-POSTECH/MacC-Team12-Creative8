//
//  SetlistListModel.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

// MARK: - SetlistListModel
public struct SetlistListModel: Codable {
  public let type: String?
  public let itemsPerPage: Int?
  public let page: Int?
  public let total: Int?
  public let setlist: [Setlist]?
}

// MARK: - Setlist
public struct Setlist: Codable {
  public let id: String?
  public let versionId: String?
  public let eventDate: String?
  public let lastUpdated: String?
  public let artist: Artist?
  public let venue: Venue?
  public let sets: Sets?
  public let url: String?
  public let info: String?
  public let tour: Tour?

  public init(id: String?, versionId: String?, eventDate: String?, lastUpdated: String?, artist: Artist?, venue: Venue?, sets: Sets?, url: String?, info: String?, tour: Tour?) {
    self.id = id
    self.versionId = versionId
    self.eventDate = eventDate
    self.lastUpdated = lastUpdated
    self.artist = artist
    self.venue = venue
    self.sets = sets
    self.url = url
    self.info = info
    self.tour = tour
  }
}

// MARK: - Artist
public struct Artist: Codable, Hashable, Equatable {
  public let mbid: String?
  public let name: String?
  public let sortName: String?
  public let disambiguation: String?
  public let url: String?

  public init(mbid: String?, name: String?, sortName: String?, disambiguation: String?, url: String?) {
    self.mbid = mbid
    self.name = name
    self.sortName = sortName
    self.disambiguation = disambiguation
    self.url = url
  }
}

// MARK: - Sets
public struct Sets: Codable {
  public let setsSet: [Session]?

  public init(setsSet: [Session]?) {
    self.setsSet = setsSet
  }

  enum CodingKeys: String, CodingKey {
    case setsSet = "set"
  }
}

// MARK: - Session
public struct Session: Codable, Hashable {
    public let song: [Song]?
    public let encore: Int?
    public let name: String?

    public init(song: [Song]?, encore: Int?, name: String?) {
        self.song = song
        self.encore = encore
        self.name = name
    }
}

extension Session: Equatable {
    public static func == (lhs: Session, rhs: Session) -> Bool {
        return lhs.song == rhs.song &&
               lhs.encore == rhs.encore &&
               lhs.name == rhs.name
    }
}

// MARK: - Song
public struct Song: Codable, Hashable, Equatable {
  public static func == (lhs: Song, rhs: Song) -> Bool {
    return lhs.name == rhs.name && lhs.info == rhs.info && lhs.cover == rhs.cover && lhs.tape == rhs.tape
  }
  
  public let name: String?
  public let info: String?
  public let cover: Artist?
  public let tape: Bool?
}

// MARK: - Tour
public struct Tour: Codable {
  public let name: String?
}

// MARK: - Venue
public struct Venue: Codable {
  public let id: String?
  public let name: String?
  public let city: City?
  public let url: String?
}

// MARK: - City
public struct City: Codable {
  public let id: String?
  public let name: String?
  public let state: String?
  public let stateCode: String?
  public let coords: Coords?
  public let country: Country?
}

// MARK: - Coords
public struct Coords: Codable {
  public let lat: Double?
  public let long: Double?
}

// MARK: - Country
public struct Country: Codable {
  public let code: String?
  public let name: String?
}
