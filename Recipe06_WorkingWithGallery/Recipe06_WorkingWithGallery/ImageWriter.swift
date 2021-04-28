//
//  ImageWriter.swift
//  Recipe06_WorkingWithGallery
//
//  Created by Gavin Xiang on 2021/4/28.
//

import UIKit
import Photos
import AssetsLibrary

class ImageWriter: NSObject {
    @objc
    class func deprecatedWriteImageToAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc
    class func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
    }

    @objc
    class func writeImageToAlbum(image: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { (isSuccess, error) in
            if isSuccess {
                print("Save success!")
            } else {
                print("Save failed:", error?.localizedDescription ?? "")
            }
        }
    }

    @objc
    class func writeImageToAlbum(image: UIImage, albumName: String?) {
        guard (albumName != nil && albumName!.count > 0) else {
            writeImageToAlbum(image: image)
            return
        }
        
        typealias AddImageBlock = (_ assetCollection: PHAssetCollection)->Void
        var addImageBlock: AddImageBlock
        addImageBlock = {(assetCollection: PHAssetCollection) in
            PHPhotoLibrary.shared().performChanges {
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                albumChangeRequest?.addAssets([assetPlaceholder!] as NSFastEnumeration)
            } completionHandler: { (success, error) in
                if success {
                    print("Saved to Album(name: \(albumName ?? "")) success!")
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
        }
        
        // create custom album
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName!)
        let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        var assetCollectionPlaceholder: PHObjectPlaceholder!
        if let _: AnyObject = collection.firstObject {
            addImageBlock(collection.firstObject!)
        } else {
            PHPhotoLibrary.shared().performChanges {
                let createAlbumRequest: PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName!)
                assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            } completionHandler: { (success, error) in
                if (success) {
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [assetCollectionPlaceholder.localIdentifier], options: nil)
                    addImageBlock(collectionFetchResult.firstObject!)
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
        }
    }
}
