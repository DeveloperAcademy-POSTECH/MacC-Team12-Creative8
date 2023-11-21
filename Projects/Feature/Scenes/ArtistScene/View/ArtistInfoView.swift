//
//  ArtistInfoView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct ArtistInfoView: View {
  @ObservedObject var vm: ArtistViewModel
  @Query var concertInfo: [ArchivedConcertInfo]
  @Query var likeArtist: [LikeArtist]
  @Environment(\.modelContext) var modelContext
  @Environment(\.scenePhase) var scenePhase
  
  var body: some View {
    ZStack(alignment: .bottom) {
      imageLayer
      HStack {
        nameLayer
        Spacer()
        buttonLayer
      }
      .padding()
    }
    .padding()
    .onAppear {
      vm.swiftDataManager.modelContext = modelContext
      vm.isLikedArtist = vm.swiftDataManager.isAddedLikeArtist(likeArtist, vm.artistInfo.mbid)
    }
    .onChange(of: scenePhase) {
                    if scenePhase == .inactive || scenePhase == .background {
                      if vm.isLikedArtist && !vm.swiftDataManager.isAddedLikeArtist(likeArtist, vm.artistInfo.mbid) { // 뷰를 나갈 때 swiftData에 추가되어있지 않은 상태에서 하트를 눌렀으면
                        vm.swiftDataManager.addLikeArtist(
                          name: vm.artistInfo.name,
                          country: "",
                          alias: vm.artistInfo.alias ?? "",
                          mbid: vm.artistInfo.mbid,
                          gid: vm.artistInfo.gid ?? 0,
                          imageUrl: vm.artistInfo.imageUrl ?? "",
                          songList: vm.artistInfo.songList ?? []
                        )
                      }
                      if !vm.isLikedArtist && vm.swiftDataManager.isAddedLikeArtist(likeArtist, vm.artistInfo.mbid) { // 뷰를 나갈 때 swiftData에 추가되어있는 상태에서 하트를 누르지 않았으면
                        vm.swiftDataManager.findArtistAndDelete(likeArtist, vm.artistInfo.mbid)
                      }
                    }
                }
  }
  
  private var imageLayer: some View {
    if let imageUrl = vm.artistInfo.imageUrl {
      return AnyView(AsyncImage(url: URL(string: imageUrl)) { image in
        image
          .centerCropped()
          .aspectRatio(1.5, contentMode: .fit)
          .cornerRadius(14)
          .overlay(Color.black.opacity(0.2).cornerRadius(14))
      } placeholder: {
        ProgressView()
      })
    } else {
      return AnyView(Image("artistViewTicket", bundle: Bundle(identifier: "com.creative8.seta.UI"))
        .renderingMode(.template)
        .foregroundStyle(Color.lineGrey1)
        .background {
          Color.mainGrey1
            .cornerRadius(14)
        }
      )
    }
  }
  
  private var nameLayer: some View {
    Text(vm.artistInfo.name)
      .font(.largeTitle)
      .fontWeight(.semibold)
      .foregroundStyle(Color.mainWhite)
  }
  
  private var buttonLayer: some View {
    Button {
      vm.isLikedArtist.toggle()
    } label: {
      Circle()
        .frame(width: UIWidth * 0.15)
        .foregroundStyle(Color.mainWhite)
        .overlay(
          Image(systemName: vm.isLikedArtist ? "heart.fill" : "heart")
            .foregroundStyle(vm.isLikedArtist ? Color.mainOrange : Color.mainWhite1)
            .font(.title3)
        )
    }
    .onDisappear {
      if vm.isLikedArtist && !vm.swiftDataManager.isAddedLikeArtist(likeArtist, vm.artistInfo.mbid) { // 뷰를 나갈 때 swiftData에 추가되어있지 않은 상태에서 하트를 눌렀으면
        vm.swiftDataManager.addLikeArtist(
          name: vm.artistInfo.name,
          country: "",
          alias: vm.artistInfo.alias ?? "",
          mbid: vm.artistInfo.mbid,
          gid: vm.artistInfo.gid ?? 0,
          imageUrl: vm.artistInfo.imageUrl ?? "",
          songList: vm.artistInfo.songList ?? []
        )
      }
      if !vm.isLikedArtist && vm.swiftDataManager.isAddedLikeArtist(likeArtist, vm.artistInfo.mbid) { // 뷰를 나갈 때 swiftData에 추가되어있는 상태에서 하트를 누르지 않았으면
        vm.swiftDataManager.findArtistAndDelete(likeArtist, vm.artistInfo.mbid)
      }
    }
  }
}

#Preview {
  ArtistInfoView(vm: ArtistViewModel())
}
