//
//  ArtistFetchService.swift
//  Core
//
//  Created by A_Mcflurry on 11/25/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation

public final class ArtistFetchService: ObservableObject {
    public init() { }

    @Published public var allArtist: [OnboardingModel] = []

    public func fetchData(completion: @escaping (Bool) -> Void) {
        let serverUrl = "https://port-0-seta-server-bkcl2bloxy1ug8.sel5.cloudtype.app/api/getArtists"
        guard let url = URL(string: serverUrl) else {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            do {
                let decoder = JSONDecoder()
                let artists = try decoder.decode([OnboardingModel].self, from: data)

                DispatchQueue.main.async {
                    self.allArtist = artists
                    completion(true)
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                print("Decoding error details: \(error)")
                completion(false)
            }
        }.resume()
    }
}
