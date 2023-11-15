//
//  SettingView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/08.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

public struct SettingView: View {
  
  public init() {}
  
  public var body: some View {
    ZStack {
      Color.backgroundWhite
      ScrollView {
        VStack(alignment: .leading) {
          Text("더보기").font(.title2).fontWeight(.semibold).foregroundStyle(Color.mainBlack)
            .padding(.top, 23)
          Divider()
            .foregroundStyle(Color.lineGrey1)
            .padding(.top, 7)
            .padding(.trailing, -25)
          // 세트리스트 추가 및 수정하기
          VStack(alignment: .leading) {
            SectionTitleView(
              sectionTitle: "세트리스트 추가 및 수정하기",
              sectionDescription: "Setlist.fm에서 다녀온 공연의 세트리스트를\n추가 및 수정하세요")
            SetlistfmLinkButton(
              setlistfmURL: "https://www.setlist.fm",
              linkLabel: "Setlist.fm 바로가기")
            .padding(.bottom, 20)
          }

          // 서비스 이용 관련
          VStack(alignment: .leading) {
            Divider()
              .foregroundStyle(Color.lineGrey1)
            SectionTitleView(
              sectionTitle: "서비스 이용 관련",
              sectionDescription: "음악으로 연결되는 순간,\nSeta의 서비스 약관을 확인해보세요")
            // 이용 약관
            NavigationLink {
              ServiceExplainView()
                .navigationBarTitleDisplayMode(.inline)
            } label: {
              LinkLabelView(linkLabel: "이용 약관")
            }
            Divider()
              .foregroundStyle(Color.lineGrey1)

            // Setlist.fm 약관
            NavigationLink {
              TermsOfSetlistfm()
                .navigationBarTitleDisplayMode(.inline)
            } label: {
              LinkLabelView(linkLabel: "Setlist.fm 약관")
            }
            Divider()
              .foregroundStyle(Color.lineGrey1)

            // 문의하기
            AskView()
          }
        }
        .padding(.horizontal, 25)
        .padding(.vertical)
      }
    }
  }
}

struct SectionTitleView: View {
  
  var sectionTitle: String
  var sectionDescription: String
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(.init(sectionTitle))
        .font(.headline)
        .foregroundStyle(Color.mainBlack)
        .padding(.vertical)
      Text(.init(sectionDescription))
        .font(.footnote)
        .foregroundStyle(Color.fontGrey2)
        .padding(.bottom, 30)
    }
  }
}

struct SetlistfmLinkButton: View {
  
  var setlistfmURL: String
  var linkLabel: String
  
  var body: some View {
    Link(destination: URL(string: setlistfmURL)!, label: {
      HStack {
        Spacer()
        Text(.init(linkLabel))
          .font(.system(.callout, weight: .semibold))
        Spacer()
      }
      .frame(height: 54)
      .background(Color.mainGrey1)
      .foregroundStyle(Color.mainBlack)
      .clipShape(RoundedRectangle(cornerRadius: 14))
      .padding(.horizontal, 7)
    })
  }
}

struct LinkLabelView: View {
  
  var linkLabel: String
  
  var body: some View {
    HStack {
      Text(.init(linkLabel))
        .font(.subheadline)
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 0))
      Spacer()
      Image(systemName: "chevron.right")
        .resizable()
        .frame(width: 10, height: 15)
        .padding(EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 15))
    }
    .foregroundStyle(Color.mainBlack)
  }
}

#Preview {
  NavigationStack {
    SettingView()
  }
}
