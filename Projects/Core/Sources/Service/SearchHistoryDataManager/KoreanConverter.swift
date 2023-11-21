//
//  KoreanConverter.swift
//  Core
//
//  Created by 고혜지 on 10/18/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

public final class KoreanConverter {
  public init() {
    
  }
  
  public func findKoreanName(artist: MusicBrainzArtist) -> (String, String?) {
    var primaryAlias: String?
    
    guard let aliases = artist.aliases else { return (artist.name!, nil) }
    
    for alias in aliases {
      if ((alias.locale == "ko" || alias.locale == "ko_KR") && (alias.name?.lowercased() != artist.name?.lowercased())) {
        primaryAlias = alias.name
        return (artist.name!, primaryAlias)
      }
    }
    
    for alias in aliases {
      if (alias.primary == true) && (alias.name?.lowercased() != artist.name?.lowercased()) {
        primaryAlias = alias.name
        return (artist.name!, primaryAlias)
      }
    }
    
    if let alias = artist.aliases?[0] {
      primaryAlias = alias.name
    }
    
    return (artist.name!, primaryAlias)
  }
  
  public func findKoreanTitle(title: String, songList: [Titles]) -> String? {
    for song in songList {
      if title.lowercased() == song.title.lowercased() {
        return title
      } else if title.lowercased() == song.subTitle.lowercased() {
        return song.title
      }
    }
    
    for song in songList {
      if compareSongTitles(title.lowercased(), song.subTitle.lowercased()) >= 0.6 {
        return song.title
      }
    }
    
    return nil
  }
  
  // Levenshtein Distance를 계산하는 함수
  private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
    let len1 = s1.count
    let len2 = s2.count
    var matrix = Array(repeating: Array(repeating: 0, count: len2 + 1), count: len1 + 1)
    
    for rowIndex in 0...len1 {
      matrix[rowIndex][0] = rowIndex
    }
    
    for colIndex in 0...len2 {
      matrix[0][colIndex] = colIndex
    }
    
    for (rowIndex, char1) in s1.enumerated() {
      for (colIndex, char2) in s2.enumerated() {
        let cost = char1 == char2 ? 0 : 1
        matrix[rowIndex + 1][colIndex + 1] = min(
          matrix[rowIndex][colIndex + 1] + 1,
          matrix[rowIndex + 1][colIndex] + 1,
          matrix[rowIndex][colIndex] + cost
        )
      }
    }
    
    return matrix[len1][len2]
  }
  
  // 노래 제목 유사도 비교 함수
  private func compareSongTitles(_ title1: String, _ title2: String) -> Double {
    let distance = levenshteinDistance(title1, title2)
    let maxLength = max(title1.count, title2.count)
    return 1.0 - Double(distance) / Double(maxLength)
  }
}
