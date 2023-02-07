//
//  JSONService.swift
//  MarsPhotoExplorer
//
//  Created by Muhammed Kocabas on 2023-02-04.
//

import Foundation

class JsonService {
    static var shared = JsonService()
        
        func parseWeatherJson (data : Data) -> PhotosResponse {
            
            var photosResponse : PhotosResponse?
            do{
            photosResponse = try? JSONDecoder().decode(PhotosResponse.self, from: data)
                
            }
            return photosResponse!
            
        }

}
