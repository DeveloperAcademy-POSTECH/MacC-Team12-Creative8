//
//  ArchivingViewModel.swift
//  Feature
//
//  Created by A_Mcflurry on 10/31/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import Core
import Combine
import SwiftUI

class ArchivingViewModel: ObservableObject {
  
//  // MARK: Tab View
//  @Published var pageStack: [NavigationDelivery] = []
//  
//  private var subscription: AnyCancellable?
//  
//  init(consecutiveTaps: AnyPublisher<Void, Never>) {
//    subscription = consecutiveTaps
//      .sink { [weak self] in
//        guard let self else { return }
//        
//        withAnimation {
//          if self.pageStack.isEmpty {
//            // TODO: Scroll 최상단으로 이동
//          } else {
//            self.pageStack.removeLast()
//          }
//        }
//        
//      }
//  }
  
  static let shared = ArchivingViewModel()
  @Published var selectSegment: SelectEnum = .bookmark
	@Published var selectArtist: String = ""
	@Published var artistSet: Set<String> = []

	func insertArtistSet(_ info: [ArchivedConcertInfo]) {
    if !artistSet.isEmpty { 
      artistSet.removeAll()
      if !info.contains(where: { $0.artistInfo.name == selectArtist }) {
        selectArtist = ""
      }
    }

		for index in 0..<info.count {
			artistSet.insert(info[index].artistInfo.name)
		}
	}

  enum SelectEnum {
    case bookmark
    case likeArtist
  }
}
