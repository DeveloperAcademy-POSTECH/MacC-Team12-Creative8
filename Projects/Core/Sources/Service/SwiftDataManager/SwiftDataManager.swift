//
//  LikeArtistManager.swift
//  Feature
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.

import SwiftUI
import SwiftData

public final class SwiftDataManager: ObservableObject {
  public var modelContext: ModelContext?
  public init(modelContext: ModelContext? = nil) { self.modelContext = modelContext }

  // MARK: - Save SwiftData func
  public func save() {
    do {
      try modelContext?.save()
    } catch {
      print(error.localizedDescription)
    }
  }

  // MARK: - LikeArtist
  public func addLikeArtist(name: String,
                            country: String,
                            alias: String,
                            mbid: String,
                            gid: Int,
                            imageUrl: String?,
                            songList: [Titles]) {
    
    let descriptor = FetchDescriptor<LikeArtist>()
    let likeArtist = try? modelContext?.fetch(descriptor)
    var max = 0
    guard let likeArtist = likeArtist else { return }
    for index in 0..<likeArtist.count {
      if max < likeArtist[index].orderIndex {
        max = likeArtist[index].orderIndex
      }
    }
    let newLikeArtist = LikeArtist(artistInfo: SaveArtistInfo(name: name,
                                                              country: country,
                                                              alias: alias,
                                                              mbid: mbid,
                                                              gid: gid,
                                                              imageUrl: imageUrl ?? "",
                                                              songList: songList),
                                                              orderIndex: max+1)
    modelContext?.insert(newLikeArtist)
    self.save()
  }

  public func deleteLikeArtist(_ item: LikeArtist) {
    modelContext?.delete(item)
    self.save()
  }

  public func isAddedLikeArtist(_ infos: [LikeArtist], _ mbid: String) -> Bool {
    for info in infos {
      if info.artistInfo.mbid == mbid {
        return true
      }
    }
    return false
  }

  public func updateLikeArtistInfo(_ info: LikeArtist, _ url: String, _ songList: [Titles]) {
    info.artistInfo.imageUrl = url
    info.artistInfo.songList = songList
    self.save()
  }

  public func findArtistAndDelete(_ infos: [LikeArtist], _ mbid: String) {
    for info in infos {
      if info.artistInfo.mbid == mbid {
        modelContext?.delete(info)
      }
    }
  }

  // MARK: - SearchHistory
  public func addSearchHistory(name: String,
                               country: String,
                               alias: String,
                               mbid: String,
                               gid: Int,
                               imageUrl: String?,
                               songList: [Titles]) {
    let newSearchHistory = SearchHistory(artistInfo: SaveArtistInfo(name: name,
                                                                    country: country,
                                                                    alias: alias,
                                                                    mbid: mbid,
                                                                    gid: gid,
                                                                    imageUrl: imageUrl ?? "",
                                                                    songList: songList))
    modelContext?.insert(newSearchHistory)
    self.save()
  }

  public func deleteSearchHistory(_ item: SearchHistory) {
    modelContext?.delete(item)
    self.save()
  }

  public func deleteSearchHistoryAll() {
    do {
      try modelContext?.delete(model: SearchHistory.self)
    } catch {
      print(error.localizedDescription)
    }
    self.save()
  }

  public func findHistoryAndDelete(_ infos: [SearchHistory], _ mbid: String) {
    for info in infos {
      if info.artistInfo.mbid == mbid {
        modelContext?.delete(info)
      }
    }
  }

  // MARK: - ArchivedConcertInfo
  public func addArchivedConcertInfo(_ artistInfo: SaveArtistInfo, _ setlist: SaveSetlist) {
    let newConcert = ArchivedConcertInfo(artistInfo: artistInfo, setlist: setlist)
    modelContext?.insert(newConcert)
  }

  public func deleteArchivedConcertInfo(_ item: ArchivedConcertInfo) {
    modelContext?.delete(item)
  }

  public func isAddedConcert(_ infos: [ArchivedConcertInfo], _ setlistId: String) -> Bool {
    for concertInfo in infos {
      if concertInfo.setlist.setlistId == setlistId {
        return true
      }
    }
    return false
  }

  public func findConcertAndDelete(_ infos: [ArchivedConcertInfo], _ setlistId: String) {
    for concertInfo in infos {
      if concertInfo.setlist.setlistId == setlistId {
        modelContext?.delete(concertInfo)
      }
    }
  }
}
