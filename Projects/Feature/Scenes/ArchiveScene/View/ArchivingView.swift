//
//  ArchivingView.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct ArchivingView: View {
  @Binding var selectedTab: Tab
  @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]
  @Query(sort: \ArchivedConcertInfo.setlist.date, order: .reverse) var concertInfo: [ArchivedConcertInfo]
  @StateObject var viewModel = ArchivingViewModel.shared

  var body: some View {
    VStack(alignment: .leading) {
      Text("보관함").font(.title2).fontWeight(.semibold).foregroundStyle(Color.mainBlack)
        .padding(.top, 23)
      Divider()
        .foregroundStyle(Color.lineGrey1)
        .padding(.trailing, -25)
        .padding(.top, 7)
      segmentedButtonsView
      if viewModel.selectSegment == .bookmark {
        bookmarkView
      } else {
        artistView
      }
    }
    .padding(.horizontal, 25)
    .padding(.vertical)
  }
}

#Preview {
  NavigationStack {
    ArchivingView(selectedTab: .constant(.archiving))
  }
}

extension ArchivingView {
  private var segmentedButtonsView: some View {
    HStack {
      Button("북마크한 공연") {
        viewModel.selectSegment = .bookmark
      }
      .foregroundStyle(viewModel.selectSegment == .bookmark ? Color.mainBlack : Color.fontGrey3)

      Button(.init("찜한 아티스트")) {
        viewModel.selectSegment = .likeArtist
      }
      .foregroundStyle(viewModel.selectSegment == .bookmark ? Color.fontGrey3 : Color.mainBlack)
      .padding(.horizontal)
    }
    .font(.headline)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.top)
  }
  
  private var bookmarkView: some View {
    Group {
      if concertInfo.isEmpty {
        IsEmptyCell(type: .bookmark)
      } else {
        ScrollView {
          bookmarkListView
        }
        .scrollIndicators(.hidden)
      }
    }
  }
  
  private var bookmarkListView: some View {
    VStack {
      ScrollView(.horizontal) {
        HStack {
          ForEach(viewModel.artistSet.sorted(), id: \.self) { artist in
            Button {
              if viewModel.selectArtist == artist {
                viewModel.selectArtist = ""
              } else {
                viewModel.selectArtist = artist
              }
            } label: {
              ArtistSetCell(name: artist, isSelected: viewModel.selectArtist.contains(artist))
            }
          }
        }
      }
      .scrollIndicators(.hidden)
      .padding(.vertical)
      
      ForEach(concertInfo) { item in
        if viewModel.selectArtist.isEmpty || viewModel.selectArtist.contains(item.artistInfo.name) {
          ArchiveConcertInfoCell(selectedTab: $selectedTab, info: item)
          Divider()
            .foregroundStyle(Color.lineGrey1)
            .padding(.horizontal)
        }
      }
      .padding(.horizontal, -25)
    }
    .onAppear { viewModel.insertArtistSet(concertInfo) }
    .onChange(of: concertInfo) { _, newValue in
      viewModel.insertArtistSet(newValue)
    }
  }
  
  private var artistView: some View {
    Group {
      if likeArtists.isEmpty {
        IsEmptyCell(type: .likeArtist)
      } else {
        List {
          Text("찜한 아티스트 중 상단의 5명이 메인화면에 등장합니다\n변경을 원하신다면 아티스트를 꾹 눌러 순서를 옮겨주세요")
            .font(.footnote)
            .foregroundStyle(Color.fontGrey2)
            .padding(.top)
            .listRowBackground(Color.backgroundWhite)
          artistListView
            .listRowSeparator(.hidden)
            .listRowBackground(Color.backgroundWhite)
        }
        
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .padding(EdgeInsets(top: -10, leading: -18, bottom: -10, trailing: -18))
      }
    }
  }
  
  private var artistListView: some View {
    ForEach(Array(likeArtists.enumerated()), id: \.element) { index, item in
      HStack {
        ArchiveArtistCell(artistUrl: URL(string: item.artistInfo.imageUrl), isNewUpdate: false)
        Text("\(item.artistInfo.name)")
          .font(.subheadline)
          .foregroundStyle(index < 5 ? Color.mainOrange : Color.mainBlack)
          .background(
            NavigationLink("", destination: ArtistView(selectedTab: $selectedTab,
                                                       artistName: item.artistInfo.name,
                                                       artistAlias: item.artistInfo.alias,
                                                       artistMbid: item.artistInfo.mbid))
            .opacity(0)
          )
        Spacer()
        MenuButton(selectedTab: $selectedTab, item: item)
      }
    }
    .onMove { source, destination in
      var updatedItems = likeArtists
      updatedItems.move(fromOffsets: source, toOffset: destination)
      for (index, item) in updatedItems.enumerated() {
        item.orderIndex = likeArtists.count - 1 - index
      }
    }
  }
}
