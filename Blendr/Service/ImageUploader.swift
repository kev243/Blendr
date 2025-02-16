//
//  ImageUploader.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-20.
//

import Foundation
import Supabase
import UIKit


class ImageUploader {
    
    static let shared = ImageUploader()
    
    private let supabaseClient = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey)
    
    func uploadImage(_ image: UIImage) async throws -> String? {
        // Convert the image to JPEG data with a compression quality of 0.25
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }

        // Generate a unique filename for the image
        let filename = UUID().uuidString + ".jpg"

        let bucket = supabaseClient.storage.from("profile_image")
        
        // Upload the image data
        do {
            _ = try await bucket.upload(
                path: filename,
                file: imageData,
                options: FileOptions(
                      contentType: "image/jpeg"
            ))
            
            let publicURL = try bucket.getPublicURL(path: filename)
            return publicURL.absoluteString
            
        } catch {
            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
            return nil
        }
    }
}


