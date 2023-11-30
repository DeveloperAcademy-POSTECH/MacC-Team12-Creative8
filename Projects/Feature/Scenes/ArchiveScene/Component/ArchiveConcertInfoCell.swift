//
//  ArchiveConcertInfoCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/30/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

struct ArchiveConcertInfoCell: View {
  @Binding var selectedTab: Tab
  let info: ArchivedConcertInfo
  let dataServiece = SetlistDataService()
  @StateObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  
  var body: some View {
    HStack {
      NavigationLink(value: NavigationDelivery(setlistId: info.setlist.setlistId, artistInfo: SaveArtistInfo(name: info.artistInfo.name, country: "", alias: "", mbid: info.artistInfo.mbid, gid: 0, imageUrl: "", songList: []))) {
          VStack {
            Text(DateFormatter.yearFormatter().string(from: info.setlist.date)).foregroundStyle(Color.fontGrey25).tracking(0.5)
            Text(DateFormatter.dateMonthFormatter().string(from: info.setlist.date)).foregroundStyle(Color.mainBlack)
          }
          .font(.headline)
          Spacer()
            .frame(width: UIWidth * 0.08)
          VStack(alignment: .leading) {
            Text(info.artistInfo.name).font(.subheadline).foregroundStyle(Color.mainBlack)
            Text(info.setlist.venue).font(.footnote).foregroundStyle(Color.mainBlack)
          }
          .lineLimit(1)
          .frame(width: UIWidth * 0.5, alignment: .leading)
          .padding(.vertical, 10)
        }
      
      Spacer()
      
      Menu {
        NavigationLink(value: NavigationDelivery(artistInfo: SaveArtistInfo(name: info.artistInfo.name, country: "", alias: info.artistInfo.alias, mbid: info.artistInfo.mbid, gid: 0, imageUrl: "", songList: []))) {
          Text("아티스트 보기")
        }
        NavigationLink(value: NavigationDelivery(setlistId: info.setlist.setlistId, artistInfo: SaveArtistInfo(name: info.artistInfo.name, country: "", alias: info.artistInfo.alias, mbid: info.artistInfo.mbid, gid: 0, imageUrl: "", songList: []))) {
            Text("세트리스트 보기")
          }
        Button("공연 북마크 취소") { dataManager.deleteArchivedConcertInfo(info) }
      } label: {
        Image(systemName: "ellipsis")
          .font(.title3)
          .foregroundStyle(Color.mainBlack)
          .padding()
      }
    }
    .padding(.horizontal, 24)
    .onAppear { dataManager.modelContext = modelContext }
  }
}
