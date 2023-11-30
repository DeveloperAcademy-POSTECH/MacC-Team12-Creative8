//
//  OnboardingModel.swift
//  Core
//
//  Created by 최효원 on 11/2/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation

public struct OnboardingModel: Decodable, Hashable {
    public var name: String
    public var mbid: String
    public var alias: String
    public var url: String?
    public var gid: Int
    public var country: String
    public var tags: [String]?
}

public enum OnboardingFilterType: LocalizedStringResource, CaseIterable {
  case all = "전체"  // 전체
  case kpop = "케이팝"  // 케이팝
  case pop = "팝"  // 팝
  case hiphop = "힙합"  // 힙합
  case rnb = "알앤비"  // 알앤비
  case rock = "락"  // 락
  case metal = "메탈"  // 메탈
  case elctronic = "일렉트로닉"  // 일렉트로닉
  case folk = "포크"  // 포크
  case jpop = "제이팝"  // 제이팝
}
