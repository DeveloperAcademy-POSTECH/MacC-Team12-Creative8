//
//  MainView.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation
import SwiftUI
import SwiftData
import Core
import UI
import Combine

public struct MainView: View {
  @Binding var selectedTab: Tab
  @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]
  @StateObject var viewModel = MainViewModel()
  @State var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  @StateObject var tabViewManager: TabViewManager
  
  public var body: some View {
    NavigationStack(path: $tabViewManager.pageStack) {
      Group {
        if likeArtists.isEmpty {
          EmptyMainView(selectedTab: $selectedTab)
        } else {
          ScrollView {
            mainArtistsView
              .padding(.top, 11)
              .id(likeArtists)
          }
          .scrollIndicators(.hidden)
          .onReceive(tabViewManager.$scrollToTop) { _ in
            withAnimation {
              viewModel.scrollToIndex = 0
              viewModel.selectedIndex = 0
            }
          }
        }
      }
      .padding(.vertical)
      .background(Color.backgroundWhite)
      .onAppear {
        dataManager.modelContext = modelContext
        var idx = 0
        if viewModel.setlists[0] == nil {
          for artist in likeArtists {
            viewModel.getSetlistsFromSetlistFM(artistMbid: artist.artistInfo.mbid, idx: idx)
            idx += 1
          }
        }
      }
      .onChange(of: likeArtists) { _, newValue in
        var idx = 0
        for artist in newValue {
          viewModel.getSetlistsFromSetlistFM(artistMbid: artist.artistInfo.mbid, idx: idx)
          idx += 1
        }
      }
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
  
  public var mainArtistsView: some View {
    VStack(spacing: 0) {
      artistNameScrollView
      artistContentView
    }
    .onChange(of: viewModel.scrollToIndex) {
      viewModel.selectedIndex = viewModel.scrollToIndex
    }
  }
  public var artistNameScrollView: some View {
    ScrollView(.horizontal) {
      ScrollViewReader { scrollViewProxy in
        HStack(spacing: UIWidth * 0.12) {
          ForEach(Array(likeArtists.enumerated().prefix(5)), id: \.offset) { index, data in
            let artistName = viewModel.replaceFirstSpaceWithNewline(data.artistInfo.name)
            ArtistNameView(selectedTab: $selectedTab,
                           viewModel: viewModel,
                           index: index, name: artistName)
            .id(index)
            .onTapGesture {
              withAnimation {
                viewModel.selectedIndex = index
                viewModel.scrollToIndex = index
              }
            }
          }
          Color.clear
            .frame(width: UIWidth * 0.7)
        }
        .frame(height: UIWidth * 0.22)
        .onAppear {
          if viewModel.selectedIndex == nil || viewModel.scrollToIndex == nil {
            if !likeArtists.isEmpty {
              viewModel.selectedIndex = 0
              viewModel.scrollToIndex = 0
            }
          }
        }
        .onChange(of: viewModel.scrollToIndex) {
          viewModel.selectedIndex = viewModel.scrollToIndex
          withAnimation(.easeInOut(duration: 0.3)) {
            scrollViewProxy.scrollTo(viewModel.scrollToIndex, anchor: .leading)
          }
        }
        .onChange(of: likeArtists, { _, _ in
          viewModel.selectedIndex = 0
          viewModel.scrollToIndex = 0
        })
        .scrollTargetLayout()
      }
    }
    .scrollIndicators(.hidden)
    .safeAreaPadding(.leading, UIWidth * 0.094)
  }
  public var artistContentView: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 12) {
        ForEach(Array(likeArtists.enumerated().prefix(5)), id: \.offset) { index, data in
          ArtistsContentView(selectedTab: $selectedTab, viewModel: viewModel, artistInfo: data.artistInfo, index: index)
        }
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.viewAligned)
    .scrollIndicators(.hidden)
    .scrollPosition(id: $viewModel.scrollToIndex)
    .safeAreaPadding(.horizontal, UIWidth * 0.092)
    .safeAreaPadding(.trailing, UIWidth * 0.005)
  }
}

#Preview {
  MainView(selectedTab: .constant(.home), viewModel: MainViewModel(), tabViewManager: .init(consecutiveTaps: Empty().eraseToAnyPublisher()))
}
