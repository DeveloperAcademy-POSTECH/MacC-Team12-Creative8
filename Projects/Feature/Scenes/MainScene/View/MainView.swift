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
  @Environment(\.colorScheme) var colorScheme
  
  @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]
  
  @StateObject var viewModel = MainViewModel()
  @State var dataManager = SwiftDataManager()
  
  @Environment(\.modelContext) var modelContext
  
  public var body: some View {
    GeometryReader { geometry in
      ScrollView {
        VStack {
            HStack {
              logo
                .opacity(0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 25)
            .padding(.top, 40)
            .overlay {
              HStack(spacing: 0) {
                toolbarButton
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
              .padding(.horizontal, UIWidth * 0.11)
            }
            
            Divider()
              .padding(.leading, 25)
              .foregroundStyle(Color.lineGrey1)
            if likeArtists.isEmpty {
              EmptyMainView(selectedTab: $selectedTab)
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height * 0.9)
            } else {
              mainArtistsView
            }
          }
          .padding(.vertical)
      }
      .scrollIndicators(.hidden)
      .id(likeArtists)
      .background(Color.backgroundWhite)
    }
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
  }
  public var logo: some View {
    HStack(spacing: 0) {
      Rectangle()
        .frame(width: 19, height: 20)
        .cornerRadius(50, corners: .bottomRight)
        .cornerRadius(50, corners: .bottomLeft)
      Rectangle()
        .frame(width: 18, height: 20)
        .cornerRadius(50, corners: .topRight)
        .cornerRadius(50, corners: .topLeft)
    }
    .foregroundColor(Color.mainBlack)
  }
  public var toolbarButton: some View {
    ZStack(alignment: .trailingFirstTextBaseline) {
      Button {
        viewModel.isTapped.toggle()
      } label: {
        if colorScheme == .dark {
          Image(systemName: "sun.max.fill")
            .font(.title3)
        } else {
          Image(systemName: "moon.stars.fill")
            .font(.title3)
        }
      }
      .foregroundColor(Color.mainBlack)
      .opacity(viewModel.isTapped ? 0 : 1)
      if viewModel.isTapped {
        ToolbarDarkModeButtons(viewModel: viewModel)
          .padding(.top)
      }
    }
    .onDisappear {
      if viewModel.isTapped {
        viewModel.isTapped = false
      }
    }
  }
  public var mainArtistsView: some View {
    VStack(spacing: 0) {
      artistNameScrollView
      artistContentView
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $viewModel.scrollToIndex)
        .safeAreaPadding(.horizontal, UIWidth * 0.11)
      Spacer()
    }
    .onChange(of: viewModel.scrollToIndex) {
      viewModel.selectedIndex = viewModel.scrollToIndex
    }
  }
  public var artistNameScrollView: some View {
    ScrollView(.horizontal) {
      ScrollViewReader { scrollViewProxy in
        HStack(spacing: UIWidth * 0.13) {
          ForEach(Array(likeArtists.enumerated().prefix(5)), id: \.offset) { index, data in
            let artistName = viewModel.replaceFirstSpaceWithNewline(data.artistInfo.name)
            Text(.init(artistName))
              .padding(.vertical, 16.5)
              .background(Color.clear)
              .font(.system(size: 25))
              .bold()
              .id(index)
              .foregroundColor(viewModel.selectedIndex == index ? Color.mainBlack : Color.fontGrey3)
              .animation(.easeInOut(duration: 0.2))
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
    .frame(minWidth: UIWidth * 0.16)
    .scrollIndicators(.hidden)
    .safeAreaPadding(.leading, UIWidth * 0.13)
  }
  public var artistContentView: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 16) {
        ForEach(Array(likeArtists.enumerated().prefix(5)), id: \.offset) { index, data in
          VStack(spacing: 0) {
              NavigationLink(destination: ArtistView(selectedTab: $selectedTab, artistName: data.artistInfo.name, artistAlias: data.artistInfo.alias, artistMbid: data.artistInfo.mbid)) {
                if data.artistInfo.imageUrl.isEmpty {
                  artistEmptyImage
                } else {
                  let imageUrl = data.artistInfo.imageUrl
                  ArtistImage(selectedTab: $selectedTab, imageUrl: imageUrl)
                }
              }
              .buttonStyle(BasicButtonStyle())
              HStack {
                Text("\(data.artistInfo.name)의 최근 공연")
                  .font(.caption)
                  .foregroundStyle(Color.fontGrey2)
                Spacer()
              }
              .opacity(viewModel.selectedIndex == index ? 1.0 : 0)
              .padding(.top)
              .padding(.horizontal, 11)
              if viewModel.isLoading {
                VStack {
                  Spacer()
                  ProgressView()
                  Spacer()
                }
                .frame(width: UIWidth, height: UIHeight * 0.3) //TODO: 수정 필요!
              } else {
                let current: [Setlist?] = viewModel.setlists[index] ?? []
                ForEach(Array(current.prefix(3).enumerated()), id: \.element?.id) { setlist, item in
                  let dateAndMonth = viewModel.getFormattedDateAndMonth(date: item?.eventDate ?? "")
                  let year = viewModel.getFormattedYear(date: item?.eventDate ?? "")
                  let city = item?.venue?.city?.name ?? ""
                  let country = item?.venue?.city?.country?.name ?? ""
                  let firstSong = item?.sets?.setsSet?.first?.song?.first?.name ?? "세트리스트 정보가 아직 없습니다"
                  let setlistId = item?.id ?? ""
                  let artistInfo = ArtistInfo(
                    name: data.artistInfo.name,
                    alias: data.artistInfo.alias,
                    mbid: data.artistInfo.mbid,
                    gid: data.artistInfo.gid,
                    imageUrl: data.artistInfo.imageUrl,
                    songList: data.artistInfo.songList)
                  VStack(spacing: 0) {
                      ArtistSetlistCell(dateAndMonth: dateAndMonth ?? "", year: year ?? "", city: city, country: country, firstSong: firstSong, setlistId: setlistId, artistInfo: artistInfo)
                    if let lastIndex = current.prefix(3).lastIndex(where: { $0 != nil }), setlist != lastIndex {
                      Divider()
                        .foregroundStyle(Color.lineGrey1)
                    }
                  }
                  .opacity(viewModel.selectedIndex == index ? 1.0 : 0)
                  .animation(.easeInOut(duration: 0.1))
                  .frame(width: UIWidth * 0.78)
                  .id(index)
                }
                if current.isEmpty {
                  EmptyMainSetlistView()
                    .opacity(viewModel.selectedIndex == index ? 1.0 : 0)
                    .padding(.vertical)
                }
              }
              Spacer()
          }
        }
      }
      .scrollTargetLayout()
    }
  }
  public var artistEmptyImage: some View {
    RoundedRectangle(cornerRadius: 15)
      .foregroundStyle(Color.mainGrey1)
      .overlay(
        Image("ticket", bundle: setaBundle)
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(Color.lineGrey1)
          .aspectRatio(contentMode: .fit)
          .frame(width: UIWidth * 0.43)
      )
      .overlay {
        artistImageOverlayButton
      }
      .frame(width: UIWidth * 0.78, height: UIWidth * 0.78)
  }
  
  public var artistImageOverlayButton: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Circle()
          .frame(width: UIWidth * 0.15)
          .foregroundStyle(Color.mainBlack)
          .overlay {
            Image(systemName: "arrow.right")
              .font(.title3)
              .foregroundStyle(Color.settingTextBoxWhite)
          }
      }
    }
    .padding([.trailing, .bottom])
  }
}

// 로고 만들기
extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape( RoundedCorner(radius: radius, corners: corners) )
  }
}
struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

#Preview {
  MainView(selectedTab: .constant(.home))
}
