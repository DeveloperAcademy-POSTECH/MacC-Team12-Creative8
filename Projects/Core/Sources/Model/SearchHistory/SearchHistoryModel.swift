//
//  SearchHistoryModel.swift
//  Core
//
//  Created by A_Mcflurry on 10/10/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import SwiftData

@Model
public final class SearchHistory {
  public var id: UUID?
  public var artistInfo: SaveArtistInfo = SaveArtistInfo(name: "", country: "", alias: "", mbid: "", gid: 0, imageUrl: "", songList: [])
  public var createdDate: Date = Date()

  init(artistInfo: SaveArtistInfo) {
    self.id = UUID()
    self.artistInfo = artistInfo
    self.createdDate = Date()
  }
}
