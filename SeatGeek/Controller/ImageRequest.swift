//
//  ImageRequest.swift
//  SeatGeek
//
//  Created by Clay Suttner on 1/29/21.
//

// Class manages retreival of image data

import UIKit

class ImageRequest {
    var resourceUrl: URL
    
    // Pass in resource URL for the image
    // No need to cast as JSON data for image property already parsed to URL
    init(resourceUrl: URL) {
        self.resourceUrl = resourceUrl
    }
    
    // A more simple URL request could be used for an image, but this is safe
    func getImage(completion: @escaping(Result<UIImage, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceUrl) { data, _, _ in
            guard let data = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            if let image = UIImage(data: data) {
                completion(.success(image))
            }
            
            completion(.failure(.cantProcessData))
        }
        dataTask.resume()
    }
    
}
