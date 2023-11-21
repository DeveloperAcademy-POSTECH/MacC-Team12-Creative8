//
//  SearchView.swift
//  Feature
//
//  Created by 최효원 on 10/7/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import Core
import SwiftData
import UI

struct SearchView: View {
  @Binding var selectedTab: Tab
  @Query(sort: \SearchHistory.createdDate, order: .reverse) private var history: [SearchHistory] = []
  @StateObject var viewModel = SearchViewModel()
  @Environment (\.modelContext) var modelContext
  @StateObject var dataManager = SwiftDataManager()
  @State private var randomIndexes: [Int] = []
  
  var body: some View {
    VStack(spacing: 0) {
      SearchBar(text: $viewModel.searchText, isEditing: $viewModel.searchIsPresented)
        .padding(.top)
        .padding(.top)
        ScrollView {
          artistView
        }
        .scrollDisabled(viewModel.searchIsPresented)
        .scrollIndicators(.hidden)
        .overlay {
          if viewModel.searchIsPresented {
            ScrollView {
              searchingHistoryView
                .padding(.top, 32)
            }
            .scrollIndicators(.hidden)
          }
        }
    }
    .padding(.horizontal)
    .background(Color.backgroundWhite)
    .onAppear {
      generateRandomIndexes()
    }
  }
  
  private var artistView: some View {
    VStack(alignment: .leading) {
      domesticArtistView
        .padding(.vertical, 64)
      foreignArtistView
    }
    .background(Color.backgroundWhite)
    .disabled(viewModel.searchIsPresented)
    .opacity(viewModel.searchIsPresented ? 0 : 1)
  }
  
  private var domesticArtistView: some View {
    VStack(alignment: .leading) {
      Text("국내 아티스트").bold()
        .foregroundStyle(Color.mainBlack)
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
        ForEach(randomIndexes, id: \.self) { index in
          if let imageURL = koreanArtistModel[index].imageUrl {
            SearchArtistCell(selectedTab: $selectedTab, imageURL: imageURL, artistName: koreanArtistModel[safe: index]?.name ?? "", artistMbid: koreanArtistModel[safe: index]?.mbid ?? "")
          }
        }
      }
    }
  }
  
  private var foreignArtistView: some View {
    VStack(alignment: .leading) {
      Text("해외 아티스트").bold()
        .foregroundStyle(Color.mainBlack)
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
        ForEach(randomIndexes, id: \.self) { index in
          if let imageURL = foreignArtistModel[index].imageUrl {
            SearchArtistCell(selectedTab: $selectedTab, imageURL: imageURL, artistName: foreignArtistModel[safe: index]?.name ?? "", artistMbid: foreignArtistModel[safe: index]?.mbid ?? "")
          }
        }
      }
    }
  }
  
  private func generateRandomIndexes() {
    let count = 9
    randomIndexes = Array(koreanArtistModel.indices.shuffled().prefix(count))
  }
  
  private var searchingHistoryView: some View {
        VStack {
          if viewModel.searchText.isEmpty {
            HStack {
              Text("최근 검색")
                .bold()
                .foregroundStyle(Color.mainBlack)
              Spacer()
              Button("모두 지우기") {
                dataManager.deleteSearchHistoryAll()
              }
              .foregroundStyle(Color.mainOrange)
              .bold()
            }
            ForEach(history, id: \.self) { item in
              SearchHistoryCell(searchText: $viewModel.searchText, selectedTab: $selectedTab, history: item, dataManager: dataManager)
            }
            .toolbar(viewModel.searchIsPresented ? .hidden : .visible, for: .tabBar)
          } else {
            SearchArtistList(selectedTab: $selectedTab, viewModel: viewModel)
          }
        }
      .onAppear {
        dataManager.modelContext = modelContext
      }
      .opacity(viewModel.searchIsPresented ? 1 : 0)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
}
