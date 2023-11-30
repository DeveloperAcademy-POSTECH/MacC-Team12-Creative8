//
//  SetlistView.swift
//  Feature
//
//  Created by 고혜지 on 11/1/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct SetlistView: View {
  @State var setlist: Setlist?
  var setlistId: String?
  @State var artistInfo: ArtistInfo
  
  @StateObject var vm = SetlistViewModel()
  @Query var concertInfo: [ArchivedConcertInfo]
  @Query var likeArtist: [LikeArtist]
  @Environment(\.modelContext) var modelContext
  @State private var showToastMessage = false
  
//  @State private var showToastMessageAppleMusic = false
//  @State private var showToastMessageCapture = false
  @StateObject var exportViewModel = ExportPlaylistViewModel()
  
  var body: some View {
    ZStack {
      Color.backgroundWhite
      ScrollView(showsIndicators: false) {
        VStack(spacing: -1) {
          concertInfoArea
          dotLine
          setlistArea
        }
        .background(Color.mainBlack)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { toolbarBookmarkButton } }
      }
      if let setlist = setlist {
        if !vm.isEmptySetlist(setlist) {
          ExportPlaylistButtonView(setlist: setlist,
                                   artistInfo: artistInfo,
                                   vm: vm,
                                   showToastMessageAppleMusic: $exportViewModel.showToastMessageAppleMusic,
                                   showToastMessageCapture: $exportViewModel.showToastMessageCapture,
                                   exportViewModel: exportViewModel)
        }
      }
      if showToastMessage {
        VStack {
          ToastMessageView(message: "북마크한 공연이 추가되었습니다.")
            .padding(.leading, 80)
            .padding(.trailing, 20)
          Spacer()
        }
      }
    }
    .customAlert(primaryButton: CustomAlertButton(title: "확인", action: {
      let musicList = vm.setlistSongName
      exportViewModel.addToAppleMusic(musicList: musicList, setlist: setlist)
    }), dismissButton: CustomAlertButton(title: "취소", action: {
      vm.showModal.toggle()
      exportViewModel.showAppleMusicAlert.toggle()
    }),
       isPresented: $exportViewModel.showAppleMusicAlert,
       artistInfo: artistInfo,
       setlist: setlist,
       exportViewModel: exportViewModel
    )
    .customAlert(primaryButton: CustomAlertButton(title: "확인", action: {
      // TODO: 유튜브뮤직
      vm.showModal.toggle()
    }), dismissButton: CustomAlertButton(title: "취소", action: {
      vm.showModal.toggle()
      exportViewModel.showAppleMusicAlert.toggle()
    }),
     isPresented: $exportViewModel.showYouTubeAlert,
     artistInfo: artistInfo,
     setlist: setlist,
     exportViewModel: exportViewModel
    )
    .toolbar(.hidden, for: .tabBar)
    .navigationBarTitleDisplayMode(.inline)
    .background(Color.backgroundWhite)
    .edgesIgnoringSafeArea(.bottom)
    .onAppear {
      if setlistId != nil {
        vm.isLoading = true
        vm.dataService.fetchOneSetlistFromSetlistFM(setlistId: setlistId!) { result in
          if let result = result {
            DispatchQueue.main.async {
              self.setlist = result
              vm.dataManager.modelContext = modelContext
              vm.isBookmarked = vm.dataManager.isAddedConcert(concertInfo, setlist?.id ?? "")
              vm.isLoading = false
            }
          }
        }
      } else {
        vm.dataManager.modelContext = modelContext
        vm.isBookmarked = vm.dataManager.isAddedConcert(concertInfo, setlist?.id ?? "")
      }
      
      if artistInfo.songList == nil || artistInfo.songList?.isEmpty == true {
        vm.artistDataManager.getArtistInfo(artistInfo: artistInfo) { result in
          if let result = result {
            artistInfo = result
            for artist in likeArtist {
              if artist.artistInfo.mbid == artistInfo.mbid {
                vm.dataManager.updateLikeArtistInfo(artist, artistInfo.imageUrl ?? "", artistInfo.songList ?? [])
              }
            }
          }
        }
      }
    }
  }
  
  private var concertInfoArea: some View {
    ZStack {
      Rectangle()
        .cornerRadius(14, corners: [.bottomLeft, .bottomRight])
        .foregroundStyle(Color.backgroundWhite)
        .ignoresSafeArea()
      ConcertInfoView(
        artist: artistInfo.name,
        date: vm.allDateFormatter(inputDate: setlist?.eventDate ?? "") ?? "-",
        venue: setlist?.venue?.name ?? "-",
        tour: setlist?.tour?.name ?? "-"
      )
      .padding([.horizontal, .bottom], 30)
      .padding(.vertical, 15)
    }
  }
  
  private var dotLine: some View {
    Rectangle()
      .stroke(style: StrokeStyle(dash: [5]))
      .frame(height: 1)
      .padding(.horizontal)
      .foregroundStyle(Color.fontGrey2)
  }
  
  private var setlistArea: some View {
    ZStack {
      Rectangle()
        .cornerRadius(14, corners: [.topLeft, .topRight])
        .foregroundStyle(Color.backgroundWhite)
        .ignoresSafeArea()
      if let setlist = setlist {
        if vm.isEmptySetlist(setlist) {
          EmptySetlistView()
            .padding(30)
        } else {
          ListView(setlist: setlist, artistInfo: artistInfo, vm: vm)
            .padding(30)
            .padding(.bottom, 130)
        }
      }
    }
  }
  
  private var toolbarBookmarkButton: some View {
    Button(action: {
      if vm.isBookmarked {
        vm.dataManager.findConcertAndDelete(concertInfo, setlist?.id ?? "")
      } else {
        saveData()
      }
      vm.isBookmarked.toggle()
    }, label: {
      Image(systemName: vm.isBookmarked ? "bookmark.fill" : "bookmark")
        .foregroundStyle(vm.isBookmarked ? Color.mainOrange : Color.mainBlack)
    })
  }
  
  private func saveData() {
    let newArtist = SaveArtistInfo(
      name: artistInfo.name,
      country: setlist?.venue?.city?.country?.name ?? "",
      alias: artistInfo.alias ?? "",
      mbid: artistInfo.mbid,
      gid: artistInfo.gid ?? 0,
      imageUrl: artistInfo.imageUrl ?? "",
      songList: artistInfo.songList ?? [])
    let newSetlist = SaveSetlist(
      setlistId: setlist?.id ?? "",
      date: vm.convertDateStringToDate(setlist?.eventDate ?? "") ?? Date(),
      venue: setlist?.venue?.name ?? "",
      title: setlist?.tour?.name ?? "",
      city: setlist?.venue?.city?.name ?? "",
      country: setlist?.venue?.city?.country?.name ?? "")
    
    vm.dataManager.addArchivedConcertInfo(newArtist, newSetlist)
    showToastMessage = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      showToastMessage = false
    }
  }
}

extension View {
  func customAlert( primaryButton: CustomAlertButton, dismissButton: CustomAlertButton,
                    isPresented: Binding<Bool>,
                    artistInfo: ArtistInfo,
                    setlist: Setlist?,
                    exportViewModel: ExportPlaylistViewModel
  ) -> some View {
    return modifier(CustomAlertModifier(dismissButton: dismissButton,
                                        primaryButton: primaryButton,
                                        isPresented: isPresented,
                                        artistInfo: artistInfo,
                                        setlist: setlist,
                                        exportViewModel: exportViewModel
                                       )
    )
    
  }
}
