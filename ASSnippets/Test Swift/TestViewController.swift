//
//  TestViewController.swift
//  ASSnippets
//
//  Created by Atif Saeed on 6/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

import UIKit
import Photos
import FirebaseStorage
import Alamofire
import AlamofireImage
import FirebaseFirestore


class TestViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    var profileImage: UIImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
self.imagePicker.delegate = self
        self.title = "Test Swift"
        // Do any additional setup after loading the view.
        
        /*
                            path = "users/\((weakSelf?.selectedProfile?.id)!).jpg"

        General().downloadImage(path, completion: { [weak weakSelf = self] data in
                    DispatchQueue.main.async {
                        if (data != nil) {
                            weakSelf?.selectedProfile?.imageData = data
                        } else {
                            weakSelf?.selectedProfile?.image = ""
                        }
        */
    }

    func imageURL(from string: String) -> URL {
        let URLString =
        "https://firebasestorage.googleapis.com/v0/b/onpoint-201.appspot.com/o/\(string)?alt=media"
        return URL(string: URLString)!
    }
    
    func imagePath(from string: String) -> String {
        let URLString =
        "https://firebasestorage.googleapis.com/v0/b/onpoint-201.appspot.com/o/\(string)?alt=media"
        return URLString
    }
    
    func downloadImage(_ path: String, completion: @escaping (Data?) -> Void) {
        if path.count == 0 {
            completion(nil)
            return
        }
        let ref = Storage.storage().reference(withPath: path)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(imageData)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    
    let scaledImage = imagePicture.scaledToSafeUploadSize
            //let imageData = scaledImage.jpegData(compressionQuality: 0.4)
            let imageData = UIImageJPEGRepresentation(scaledImage!, 0.5)
            
            let storageRef = Storage.storage().reference().child("users").child(profile.image)
            storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    completion(false, error, "")
                    
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            completion(false, error, "")
                            
                        } else {
                            print(url?.absoluteString ?? "")
                            let data: [String : Any] = profile.updateProfile()
                            
                                if let err = err {
                                    print("Error updating profile: \(err)")
                                    completion(false, error, "")
                                } else {
                                    print("Profile successfully updated")
                                    completion(true, error, (metadata?.path)!)
                                }
                            }
                            
                            
                        }
                        
                    }
                }
                
            })
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Photo mothods
    
    func photoAction() {
        
        let sheet = UIAlertController(title: nil, message: "Select the source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .camera)
        })
        let photoAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .library)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    func openPhotoPickerWith(source: PhotoSource) {
        photoCell?.activityIndicator.isHidden = true
        
        switch source {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        case .library:
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            isImageChanged = true
            profileImage = pickedImage
            self.photoCell?.imagePicture.image = pickedImage.af_imageRoundedIntoCircle()
            
        } else {
            self.photoCell?.imagePicture.image = UIImage(named: "icnUser")?.af_imageRoundedIntoCircle()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}


}


extension UIImage {
    
    var scaledToSafeUploadSize: UIImage? {
        let maxImageSideLength: CGFloat = 480
        
        let largerSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
        
        return image(scaledTo: newImageSize)
    }
    
    func image(scaledTo size: CGSize) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        var transform: CGAffineTransform = .identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -(.pi / 2))
        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        var ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: (cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (cgImage?.colorSpace)!, bitmapInfo: (cgImage?.bitmapInfo)!.rawValue)
        ctx?.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        let cgimg = ctx?.makeImage()
        let img = UIImage(cgImage: cgimg!)
        
        return img
    }
    
}

