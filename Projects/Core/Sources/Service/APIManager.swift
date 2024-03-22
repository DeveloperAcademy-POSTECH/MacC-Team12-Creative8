//
//  APIManager.swift
//  Core
//
//  Created by A_Mcflurry on 3/14/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import Foundation

public enum APIManager {
	case fetchMusicBrainz(mbid: String)
	case searchMusicBrainz(name: String)
	case fetchOneSetlist(setlistID: String)
	case fetchSetlists(mbid: String, page: Int)
	case searchGenius(name: String)
	case fetchSongGenius(artistID: Int, page: Int)

	var getURL: URL {
		switch self {
		case .fetchMusicBrainz(let mbid):
			return URL(string: "https://musicbrainz.org/ws/2/artist/?query=mbid:\(mbid)&fmt=json")!
		case .searchMusicBrainz(let name):
			return URL(string: "https://musicbrainz.org/ws/2/artist?query=\(name)&fmt=json")!
		case .fetchOneSetlist(let setlistID):
			return URL(string: "https://api.setlist.fm/rest/1.0/setlist/\(setlistID)")!
		case .fetchSetlists(let mbid, let page):
			return URL(string: "https://api.setlist.fm/rest/1.0/search/setlists?artistMbid=\(mbid)&p=\(page)")!
		case .searchGenius(let name):
			return URL(string: "https://api.genius.com/search?q=\(name)")!
		case .fetchSongGenius(let artistID, let page):
			return URL(string: "https://api.genius.com/artists/\(artistID)/songs?page=\(page)&per_page=50")!
		}
	}

	var method: String {
		return "GET"
	}

	var headers: [String: String] {
		switch self {
		case .fetchMusicBrainz, .searchMusicBrainz:
			return ["Authorization": APIKeys().musicBrainz]
		case .fetchOneSetlist, .fetchSetlists:
			return ["x-api-key": APIKeys().setlistFM,
					  "Accept": "application/json",
					  "Accept-Language": "en"]
		case .searchGenius, .fetchSongGenius:
			return ["Authorization": APIKeys().genius]
		}
	}
}
