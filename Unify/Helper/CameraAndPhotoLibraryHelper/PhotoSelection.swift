//
//  PhotoSelection.swift
//  CameraAndPhotoLibraryDemo
//
//  Created by Priyanka Patel on 21/05/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
//import BSImagePicker

enum photoSelectionType : Int {
    case singlePhotoType
    case singleVideoType
    case multiplePhotoType
    case multipleVideoType
}

typealias SelectionBlock = ((_ success: Bool, _ object: Any?) -> Void)?
var completionblock: SelectionBlock

extension UIViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    /**
     This method allow getting a image from camera roll or take a photo in your device.
     @param completionHandler
     The completionHandler return a UIImage if the process was successful.
     */
    func addPhoto(_ completionHandler: SelectionBlock) {
        completionblock = completionHandler
        showActionSheet(withOptionType: photoSelectionType.singlePhotoType)
    }

    /**
     This method allow getting a video from camera roll or make a video in your device.
     @param completionHandler
     The completionHandler return a AVAsset if the process was successful.
     */
    func addVideo(_ completionHandler: SelectionBlock) {
        completionblock = completionHandler
        showActionSheet(withOptionType: photoSelectionType.singleVideoType)
    }

    /**
     This method allow getting multiple images from device.
     @param completionHandler
     The completionHandler return an array of PHAssets if the process was successful.
     */
    func selectMultiplePhoto(_ completionHandler: SelectionBlock) {
        completionblock = completionHandler
        showActionSheet(withOptionType: photoSelectionType.multiplePhotoType)
    }

    /**
     This method allow getting multiple videos from device.
     @param completionHandler
     The completionHandler return an array of PHAssets if the process was successful.
     */
    func selectMultipleVideo(_ completionHandler: SelectionBlock) {
        completionblock = completionHandler
        showActionSheet(withOptionType: photoSelectionType.multipleVideoType)
    }

    func isPhotoSelection(_ photoSelectionType: photoSelectionType) -> Bool {
        return photoSelectionType == .multiplePhotoType || photoSelectionType == .singlePhotoType
    }

    func isMultipleSelection(_ photoSelectionType: photoSelectionType) -> Bool {
        return photoSelectionType == .multiplePhotoType || photoSelectionType == .multipleVideoType
    }


    func showActionSheet(withOptionType photoSelectionType: photoSelectionType) {
        var makeString = NSLocalizedString("Take Picture", comment: "")
        if !isPhotoSelection(photoSelectionType) {
            makeString = NSLocalizedString("Make a video", comment: "")
        }

        let alert:UIAlertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
            completionblock?(false,nil)
        }

        let cameraAction = UIAlertAction(title: makeString, style: .default) { UIAlertAction in

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = .camera
                cameraPicker.delegate = self
                if !self.isPhotoSelection(photoSelectionType) {
                    //cameraPicker.cameraCaptureMode = .video
                    cameraPicker.mediaTypes = [kUTTypeMovie as String]
                }
                self.present(cameraPicker, animated: true) {() -> Void in }
            }
        }
        let gallaryAction = UIAlertAction(title: "Select Picture", style: .default) { UIAlertAction in
//                        if self.isMultipleSelection(photoSelectionType) {
//                            pushToSLAlbumViewController(withSelectionType: photoSelectionType == SLMultiplePhotoType ? SLPhotoType : SLVideoType)
//                            return
//                        }


            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self

                if !self.isPhotoSelection(photoSelectionType) {
                    imagePicker.mediaTypes = [kUTTypeMovie as String]
                }
                
                self.present(imagePicker, animated: true) {() -> Void in }
            }


        }

        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)

        present(alert, animated: true) {() -> Void in }
    }

    // MARK: - Delegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        picker.dismiss(animated: true, completion: nil)
        //let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage

//        completionblock?(true,selectedImage)

        let mediaType = info[UIImagePickerControllerMediaType] as? String
        if (mediaType == "public.image") {
            let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            completionblock?(true,selectedImage)
        } else if (mediaType == "public.movie") {
            let videoURL = info[UIImagePickerControllerMediaURL] as? URL
            var avAsset: AVAsset? = nil
            if let anURL = videoURL {
                avAsset = AVURLAsset(url: anURL, options: nil)
            }
            completionblock?(true, avAsset)
        }
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        picker.dismiss(animated: true, completion: nil)
        completionblock?(false,nil)
    }
}

