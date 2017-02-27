//
//  Extensions.swift
//  DawgChat
//
//  Created by Zac on 2/27/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit

/// This cache stores images downloaded from Firebase
let imageCache = NSCache<AnyObject, AnyObject>()

// MARK: - This class extended from UIImageView handles downloaded image caches
extension UIImageView {

    // Use cache without loading image repeatedly 
    func loadImageUsingCacheWithUrlString(urlString: String)
    {
        // Reslove the image flashing while first launching
        self.image = nil
        
        // Check cache before loading image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)
        {
            self.image = cachedImage as? UIImage
            return
        }

        // Not in the cache, download from Firebase DB
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url as! URL, completionHandler: { (data, response, err) in
            
            // Download failed!
            if err != nil
            {
                print(err!)
                return
            }
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!)
                {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}
