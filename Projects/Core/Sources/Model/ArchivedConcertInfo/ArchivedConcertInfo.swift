//
//  ArchivedConcertInfo.swift
//  Core
//
//  Created by A_Mcflurry on 10/22/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftData

@Model
public class ArchivedConcertInfo {
  public var id: UUID?
  public var artistInfo: SaveArtistInfo = SaveArtistInfo(name: "", country: "", alias: "", mbid: "", gid: 0, imageUrl: "", songList: [])
  public var setlist: SaveSetlist = SaveSetlist(setlistId: "", date: Date(), venue: "", title: "", city: "", country: "")

  public init(artistInfo: SaveArtistInfo, setlist: SaveSetlist) {
    self.id = UUID()
    self.artistInfo = artistInfo
    self.setlist = setlist
  }
}
