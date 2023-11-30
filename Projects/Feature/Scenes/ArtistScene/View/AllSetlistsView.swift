//
//  AllSetlistsView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct AllSetlistsView: View {
  @ObservedObject var vm: ArtistViewModel
  
  var body: some View {
    VStack {
      titleLayer
      setlistsLayer
      if vm.page != vm.totalPage {
        buttonLayer
      }
    }
  }
  
  private var titleLayer: some View {
    HStack {
      Text("전체 공연 보기")
        .font(.headline)
        .fontWeight(.bold)
        .foregroundStyle(Color.mainBlack)
      Spacer()
    }
    .padding(EdgeInsets(top: 16, leading: 24, bottom: 24, trailing: 24))
  }
  
  private var setlistsLayer: some View {
    ForEach(vm.setlists ?? [], id: \.id) { setlist in
      NavigationLink {
        SetlistView(setlist: setlist, artistInfo: vm.artistInfo)
      } label: {
        HStack {
          // MARK: Date
          VStack {
            Text(vm.getFormattedDateFromString(date: setlist.eventDate ?? "", format: "yyyy") ?? "")
              .foregroundStyle(Color.fontGrey25)
              .tracking(0.5)
            Text(vm.dayAndMonthDateFormatter(inputDate: setlist.eventDate ?? "") ?? "")
              .foregroundStyle(Color.mainBlack)
          }
          .font(.headline)
          
          Spacer()
          
          // MARK: Venue
          VStack(alignment: .leading) {
            let venue = "\(setlist.venue?.city?.name ?? ""), \(setlist.venue?.city?.country?.name ?? "")"
            Text(venue)
              .font(.subheadline)
              .foregroundStyle(Color.mainBlack)
            Group {
              if vm.isEmptySetlist(setlist) {
                Text("세트리스트 정보가 아직 없습니다")
              } else {
                let songTitle: String = setlist.sets?.setsSet?.first?.song?.first?.name ?? ""
                Text("01 \(vm.koreanConverter.findKoreanTitle(title: songTitle, songList: vm.artistInfo.songList ?? []) ?? songTitle)")
              }
            }
            .font(.footnote)
            .foregroundStyle(Color.fontGrey25)
          }
          .lineLimit(1)
          .frame(width: UIWidth * 0.5, alignment: .leading)
          .padding(.vertical, 10)
          
          Spacer()
          
          // MARK: Arrow
          Image(systemName: "arrow.right")
            .font(.title3)
            .foregroundStyle(Color.mainBlack)
        }
        .padding(.horizontal, 24)
      }
      
      Divider()
        .padding(.horizontal, 24)
        .foregroundColor(Color.lineGrey1)
    }
  }
  
  private var buttonLayer: some View {
    VStack {
      Button {
        vm.fetchNextPage(artistMbid: vm.artistInfo.mbid)
      } label: {
        if vm.isLoadingNextPage {
          ProgressView()
            .padding()
        } else {
          Text("더보기")
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundStyle(Color.mainBlack)
            .padding()
        }
      }
      
      Divider()
        .foregroundStyle(Color.lineGrey1)
        .padding(.horizontal)
    }
  }
  
}

#Preview {
    AllSetlistsView(vm: ArtistViewModel())
}
