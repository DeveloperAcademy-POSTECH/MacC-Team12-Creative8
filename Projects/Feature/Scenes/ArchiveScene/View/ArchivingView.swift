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
import Combine

struct ArchivingView: View {
  @Binding var selectedTab: Tab
  @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]
  @Query(sort: \ArchivedConcertInfo.setlist.date, order: .reverse) var concertInfo: [ArchivedConcertInfo]
  @StateObject var viewModel = ArchivingViewModel.shared
  @StateObject var tabViewManager: TabViewManager
  @Namespace var topID
  
  var body: some View {
    NavigationStack(path: $tabViewManager.pageStack) {
      VStack {
        segmentedButtonsView
          .padding(.horizontal, 24)
          .padding(.vertical)
        if viewModel.selectSegment == .bookmark {
          bookmarkView
        } else {
          artistView
        }
      }
      .background(Color.backgroundWhite)
      .navigationTitle("보관함")
      .navigationDestination(for: NavigationDelivery.self) { value in
        if value.setlistId != nil {
          SetlistView(setlistId: value.setlistId, artistInfo: ArtistInfo(
            name: value.artistInfo.name,
            alias: value.artistInfo.alias,
            mbid: value.artistInfo.mbid,
            gid: value.artistInfo.gid,
            imageUrl: value.artistInfo.imageUrl,
            songList: value.artistInfo.songList))
        } else {
          ArtistView(selectedTab: $selectedTab, artistName: value.artistInfo.name, artistAlias: value.artistInfo.alias, artistMbid: value.artistInfo.mbid)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    ArchivingView(selectedTab: .constant(.archiving), tabViewManager: .init(consecutiveTaps: Empty().eraseToAnyPublisher()))
  }
}

extension ArchivingView {
  private var segmentedButtonsView: some View {
    HStack {
      Button("북마크한 공연") {
        viewModel.selectSegment = .bookmark
      }
      .foregroundStyle(viewModel.selectSegment == .bookmark ? Color.mainBlack : Color.fontGrey3)

      Button("찜한 아티스트") {
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
        ScrollViewReader { proxy in
          ScrollView {
            Spacer().id(topID)
            bookmarkListView
          }
          .scrollIndicators(.hidden)
          .onReceive(tabViewManager.$scrollToTop) { _ in
            withAnimation {
              proxy.scrollTo(topID)
            }
          }
        }
      }
    }
  }
  
  private var bookmarkListView: some View {
    VStack {
      ScrollView(.horizontal) {
        HStack {
          Rectangle()
            .padding(2)
            .foregroundStyle(.clear)
          Button {
            viewModel.selectArtist = ""
          } label: {
            AllArtistsSetCell(name: "전체", isSelected: viewModel.selectArtist.isEmpty)
          }
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
          .padding(.horizontal, 20)
        }
      }
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
        ScrollViewReader { proxy in
          List {
            VStack(alignment: .leading, spacing: 0) {
              Text("찜한 아티스트 중 상단의 5명이 메인화면에 등장합니다")
                .font(.footnote)
                .foregroundStyle(Color.fontGrey2)
                .padding(.top)
                .listRowBackground(Color.backgroundWhite)
              Group {
                Text("변경을 원하신다면 ")
                  .font(.footnote)
                  .foregroundStyle(Color.fontGrey2)
                +
                Text("아티스트를 꾹 눌러 순서를 옮겨보세요")
                  .font(.footnote)
                  .fontWeight(.semibold)
                  .foregroundStyle(Color.fontGrey2)
              }
            }.id(topID)
              .listRowSeparator(.hidden)
              .listRowBackground(Color.backgroundWhite)
            
            artistListView
              .listRowSeparator(.hidden)
              .listRowBackground(Color.backgroundWhite)
          }
          .scrollIndicators(.hidden)
          .listStyle(.plain)
          .padding(EdgeInsets(top: -10, leading: -18, bottom: 10, trailing: -18))
          .onReceive(tabViewManager.$scrollToTop) { _ in
            withAnimation {
              proxy.scrollTo(topID)
            }
          }
        }
      }
    }
    .padding(.horizontal, 24)
  }
  
  private var artistListView: some View {
    ForEach(Array(likeArtists.enumerated()), id: \.element) { index, item in
      HStack {
        ArchiveArtistCell(artistUrl: URL(string: item.artistInfo.imageUrl), isNewUpdate: false)
        Text("\(item.artistInfo.name)")
          .font(.subheadline)
          .foregroundStyle(index < 5 ? Color.mainOrange : Color.mainBlack)
          .background(
            NavigationLink(value: NavigationDelivery(artistInfo: SaveArtistInfo(name: item.artistInfo.name, country: "", alias: item.artistInfo.alias, mbid: item.artistInfo.mbid, gid: 0, imageUrl: "", songList: []))) {
              Text("")
            }
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
