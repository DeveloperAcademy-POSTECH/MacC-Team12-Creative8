//
//  DataService.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

public final class SetlistDataService {
  public init() {
    
  }

	public func callRequest<T: Codable>(type: T.Type, api: APIManager, _ completionHandler: @escaping (T?)->Void) {
		var request = URLRequest(url: api.getURL)
		request.httpMethod = api.method

		api.headers.forEach { key, value in
			request.addValue(value, forHTTPHeaderField: key)
		}

		URLSession.shared.dataTask(with: request) { data,_, error in
			if let error { print(error); completionHandler(nil); return }

			guard let data else { completionHandler(nil); return }

			do {
				let decodingData = try JSONDecoder().decode(T.self, from: data)
				completionHandler(decodingData)
			} catch let error {
				print(error)
				completionHandler(nil)
			}
		}.resume()
	}
}
