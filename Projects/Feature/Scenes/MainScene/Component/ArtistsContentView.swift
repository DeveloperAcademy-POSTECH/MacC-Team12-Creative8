//
//  ArtistImageAndConcertListView.swift
//  Feature
//
//  Created by 장수민 on 11/17/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData
import Core
import UI
import Combine

struct ArtistsContentView: View {
  @Binding var selectedTab: Tab
  @StateObject var viewModel: MainViewModel
  @State var artistInfo: SaveArtistInfo
  @StateObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  var index: Int
  var body: some View {
    VStack(spacing: 0) {
      artistImage
      Group {
        if !viewModel.isLoading {
          Group {
            commentText
            artistSetlistCells  // 세트리스트 불러오는화면과 세트리스트가 없는 화면
          }
          .padding(.horizontal, 2)
          .scrollTransition(.animated.threshold(.visible(0.5))) { content, phase in
            content
              .opacity(phase.isIdentity ? 1 : 0)
              .blur(radius: phase.isIdentity ? 0 : 0.5)
          }
        } else {
          ProgressView()
            .frame(width: UIWidth, height: UIWidth * 0.6) // TODO: 수정 필요!
        }
      }
    }
    .frame(width: UIWidth * 0.81)
    .onAppear {
      dataManager.modelContext = modelContext
    }
  }
  private var artistImage: some View {
    NavigationLink(value: NavigationDelivery(artistInfo: artistInfo)) {
      ArtistImage(selectedTab: $selectedTab, imageUrl: artistInfo.imageUrl)
        .frame(width: UIWidth * 0.81, height: UIWidth * 0.81)
    }
    .buttonStyle(BasicButtonStyle())
  }
  private var commentText: some View {
    HStack(spacing: 0) {
      Text("\(artistInfo.name)의 최근 공연")
        .font(.caption)
        .foregroundStyle(Color.fontGrey2)
      Spacer()
    }
    .padding(.top, UIWidth * 0.062)
  }
  private var artistSetlistCells: some View {
    VStack(spacing: 0 ) {
      let setlists: [Setlist?] = viewModel.setlists[index] ?? []
      if setlists.isEmpty {
        EmptyMainSetlistView(viewModel: viewModel)
      } else {
        ForEach(Array(setlists.prefix(3).enumerated()), id: \.element?.id) { index, item in
          VStack(alignment: .leading, spacing: 0) {
            NavigationLink(value: NavigationDelivery(setlistId: item?.id ?? "", artistInfo: artistInfo)) {
              HStack(spacing: 0) {
                VStack(alignment: .center) {
                  Text(viewModel.getFormattedYear(date: item?.eventDate ?? "yyyy") ?? "yyyy")
                    .foregroundStyle(Color.fontGrey25)
                    .tracking(0.5)
                  Text(viewModel.dayAndMonthDateFormatter(inputDate: item?.eventDate ?? "") ?? "")
                    .foregroundStyle(Color.mainBlack)
                }
                .font(.headline)
                .fontWeight(.semibold)
                Spacer()
                  .frame(width: UIWidth * 0.08)
                VStack(alignment: .leading) {
                  Group {
                    Text(item?.venue?.city?.name ?? "city")
                    +
                    Text(", ")
                    +
                    Text(item?.venue?.city?.country?.name ?? "country")
                  }
                  .font(.footnote)
                  .lineLimit(1)
                  .foregroundStyle(Color.mainBlack)
                  Group {
                    if let firstSong = item?.sets?.setsSet?.first?.song?.first?.name {
                      Text("01 \(firstSong)")
                    } else {
                      Text("세트리스트 정보가 아직 없습니다")
                    }
                  }
                  .font(.footnote)
                  .lineLimit(1)
                  .foregroundStyle(Color.fontGrey25)
                }
                Spacer()
              }
              .padding(.vertical)
            }
          }
          
          if let lastIndex = setlists.prefix(3).lastIndex(where: { $0 != nil }), index != lastIndex {
            Divider()
              .foregroundStyle(Color.lineGrey1)
          }
        }
      }
    }
    .frame(minHeight: UIWidth * 0.6, alignment: .topLeading)
  }
}

#Preview {
  ArtistsContentView(selectedTab: .constant(.home),
                     viewModel: MainViewModel(),
                     artistInfo: SaveArtistInfo(name: "Silica Gel", country: "South Korea", alias: "실리카겔", mbid: "2c8b5bb2-6110-488d-bc15-abb08379d3c6", gid: 2382659, imageUrl: "https://i.namu.wiki/i/SCZmC5XQgajMHRv6wvMc406r6aoQyf0JjXNCIQkIxJ-oe035C8h6VTkKllE6gkp3p-A7RFwiIcd0d726O77rbQ.webp", songList: []), index: 1)
}
