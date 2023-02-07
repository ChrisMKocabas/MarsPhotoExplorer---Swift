//
//  PhotoObject.swift
//  MarsPhotoExplorer
//
//  Created by Muhammed Kocabas on 2023-02-04.
//

import Foundation

struct PhotosResponse:Codable {
    let photos: [Photo]
}

struct Photo:Identifiable,Codable {
    var id : Int
    var sol : Int
    var camera : Camera
    var img_src : String
    var earth_date : String
    var rover : Rover
    
}


struct Camera:Identifiable,Codable {
    var id : Int
    var name : String
    var rover_id : Int
    var full_name : String
}


struct Rover:Identifiable,Codable {
    var id : Int
    var name : String
    var landing_date : String
    var launch_date : String
    var status : String
}
