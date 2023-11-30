//
//  MenuButton.swift
//  Feature
//
//  Created by A_Mcflurry on 11/1/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

struct MenuButton: View {
  @Binding var selectedTab: Tab
  let item: LikeArtist
  @StateObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  var body: some View {
    Menu {
      NavigationLink(value: NavigationDelivery(artistInfo: SaveArtistInfo(name: item.artistInfo.name, country: "", alias: item.artistInfo.alias, mbid: item.artistInfo.mbid, gid: 0, imageUrl: "", songList: []))) {
        Text("아티스트 보기")
      }
      Button("찜하기 취소") { dataManager.deleteLikeArtist(item) }
    } label: {
      Image(systemName: "ellipsis")
        .foregroundStyle(Color.mainBlack)
        .padding()
        .background(Color.clear)
    }
    .onAppear { dataManager.modelContext = modelContext }
  }
}
