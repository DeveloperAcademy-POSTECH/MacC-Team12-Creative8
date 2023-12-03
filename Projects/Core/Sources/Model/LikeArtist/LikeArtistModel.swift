//
//  LikeArtistModel.swift
//  Feature
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import SwiftData

@Model
public final class LikeArtist {
  public var id: UUID?
  public var artistInfo: SaveArtistInfo = SaveArtistInfo(name: "", country: "", alias: "", mbid: "", gid: 0, imageUrl: "", songList: [])
  public var orderIndex: Int = 0

  public init(artistInfo: SaveArtistInfo, orderIndex: Int) {
    self.id = UUID()
    self.artistInfo = artistInfo
    self.orderIndex = orderIndex
  }
}
