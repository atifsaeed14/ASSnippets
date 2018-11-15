/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A UINavigationController subclass that always defers queries about
  its preferred status bar style and supported interface orientations to its 
  child view controllers.
 */

#import "NavigationController.h"

@implementation NavigationController

//| ----------------------------------------------------------------------------
//  Defer returning the supported interface orientations to the navigation
//  controller's top-most view controller.
//
- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end

 /*
 
 //
//  RemoteViewController.swift
//  ASSample
//
//  Created by Atif Saeed on 07/11/2018.
//  Copyright © 2018 Company. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseFirestore
import GoogleMaps
import Firebase
import FirebaseAuth



// https://medium.com/@vikaskore/save-get-and-delete-multiple-images-from-document-directory-in-swift-db75e536b72b


class RemoteViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    private let storage = Storage.storage().reference()
    let imagePicker = UIImagePickerController()
    var folderName:String = ""
    let directory = DIRECTORY.init()
    
    let db = Firestore.firestore()
    
    // init data
    var users:[[String: Any]] = []
    var locations:[[String: Any]] = []
    var medias:[[String: Any]] = []
    var posts:[[String: Any]] = []
    var postMedias:[[String: Any]] = []
    var ranks:[[String: Any]] = []
    var postCategories:[[String: Any]] = []
    var categories:[[String: Any]] = []
    var userInterests:[[String: Any]] = []
    var interests:[[String: Any]] = []
    var postInterests:[[String: Any]] = []
    var uniqueLocations:[[String: Any]] = []
    var timelines:[[String: Any]] = []
    var dateFormatter = DateFormatter() {
        didSet {
            dateFormatter.dateFormat = "yyyy-mm-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Directory
    
    @IBAction func getUserJsonDataTapped(_ sender: Any) {
        let userFileUrl = directory.getURL("users.json")
        do {
            let data = try Data(contentsOf: userFileUrl!, options: [])
            guard let userArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
            users = userArray
            print("user done")
            
            /*
             
             set user images
             
            folderName = "user"
            var dataFiles = directory.getFiles(folderName)
            if let index = dataFiles.index(of: ".DS_Store") {
                dataFiles.remove(at: index)
            }
            
            for i in 0..<users.count {
                let imageID = "\(users[i]["udid"] ?? "").jpg"
                let index = dataFiles.index(where: { $0 == imageID })
                if index != nil {
                    users[i]["image"] = imageID
                } else {
                    users[i]["image"] = ""
                }
            }
    
            let fileUrl = self.directory.getURL("finaluser.json")
            do {
                let data = try JSONSerialization.data(withJSONObject: users, options: [])
                try data.write(to: fileUrl!, options: [])
                print("user done done")
            } catch {
                print(error)
            } */
            
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func filterPostsTapped(_ sender: Any) {
        let profileFileUrl = directory.getURL("posts-location.json")
        do {
            let data = try Data(contentsOf: profileFileUrl!, options: [])
            guard let profileArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
            
            print("post count: ", profileArray.count)
            
            let filterPlaceId = profileArray.filter { ($0["placeId"] as! String) != "0" }
            print("filterPlaceId: ",filterPlaceId.count)

            let filterUdid = filterPlaceId.filter { ($0["udid"] as! String) != "" }
            print("filterUdid: ",filterUdid.count)

            let filterCity = filterUdid.filter { ($0["city"] as! String) != "" }
            print("filterCity: ",filterCity.count)

            let filterCountry = filterCity.filter { ($0["country"] as! String) != "" }
            print("filterCountry: ",filterCountry.count)

            /*
             post count:  1172
             filterPlaceId:  1013
             filterUdid:  1013
             filterCity:  763
             filterCountry:  763
             
             removeDupPID:  435

            */
            
            // remove duplicate place id
            var removeDupPID:[[String: Any]] = []
            
            for city in filterCountry {
                let index = removeDupPID.index(where: { ($0["placeId"] as! String) == (city["placeId"] as! String) })
                if index == nil {
                    removeDupPID.append(city)
                }
            }
            print("removeDupPID: ",removeDupPID.count)
            
            
            
            
            
            
            posts = profileArray
            /*
            var city:[[String: Any]] = []
            print("profileArray done")

            for post in posts {
                let data = [ "longitude":post["longitude"]!, "latitude":post["latitude"]!, "city":post["city"]!, "country":post["country"]! ] as [String : Any]
                city.append(data)
            }
            print("city: ",city.count)
            
            let filterCity = city.filter { ($0["city"] as! String) != "" }
            print("filterCity: ",filterCity.count)
            
            var removeDup:[[String: Any]] = []
            
            for city in filterCity {
                let index = removeDup.index(where: { ($0["city"] as! String) == (city["city"] as! String) })
                if index == nil {
                    removeDup.append(city)
                }
            }
            print("removeDup: ",filterCity.count)
            */
            let fileUrl = self.directory.getURL("filter_posts.json")
            do {
                let data = try JSONSerialization.data(withJSONObject: filterCity, options: [])
                try data.write(to: fileUrl!, options: [])
                print("filter post json done")
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
    }
    
    @IBAction func getLocationTapped(_ sender: Any) {
        
        let profileFileUrl = directory.getURL("posts-location.json")
        do {
            let data = try Data(contentsOf: profileFileUrl!, options: [])
            guard let profileArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
            posts = profileArray
            print("profileArray done")
            
            var city:[[String: Any]] = []
            
            for post in posts {
                let data = [ "longitude":post["longitude"]!, "latitude":post["latitude"]!, "city":post["city"]!, "country":post["country"]! ] as [String : Any]
                city.append(data)
            }
            print("city: ",city.count)

            let filterCity = city.filter { ($0["city"] as! String) != "" }
            print("filterCity: ",filterCity.count)
            
            var removeDup:[[String: Any]] = []
            
            for city in filterCity {
                let index = removeDup.index(where: { ($0["city"] as! String) == (city["city"] as! String) })
                if index == nil {
                    removeDup.append(city)
                }
            }
            print("removeDup: ",filterCity.count)
            
            let fileUrl = self.directory.getURL("city.json")
            do {
                let data = try JSONSerialization.data(withJSONObject: removeDup, options: [])
                try data.write(to: fileUrl!, options: [])
                print("city jone done")
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }

    }
    
    @IBAction func updatePostLocationTapped(_ sender: Any) {
        // save locaiton
        
        let profileFileUrl = directory.getURL("json-posts.json")
        do {
            let data = try Data(contentsOf: profileFileUrl!, options: [])
            guard let profileArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
            posts = profileArray
            print("profileArray done")
            
            print("post: ",posts.count)
            // let udid = posts.filter { ($0["udid"] as! String) == "" }
            // print("udid: ",udid.count)
            
            let downloadGroup = DispatchGroup()
            for i in 0..<posts.count {
            // for i in 0..<5 {
                
                downloadGroup.enter()
                let latitude = Double(posts[i]["lat"] as! String)
                let longitude = Double(posts[i]["lag"] as! String)
                
                let location = CLLocation(latitude: latitude ?? 0, longitude: longitude ?? 0)
                
                GeoAPIClient.sharedInstance.getAddress(location, block: { (address) in
                    print("innerIndex: \(i)")
                    if address?.formattedAddress != nil {
                        // print(locations[i])
                        self.posts[i]["latitude"] = address?.latitude
                        self.posts[i]["longitude"] = address?.longitude
                        self.posts[i]["placeId"] = address?.placeId
                        self.posts[i]["city"] = address?.city
                        self.posts[i]["zip"] = address?.postalCode
                        self.posts[i]["location"] = address?.formattedAddress
                        self.posts[i]["state"] = address?.state
                        self.posts[i]["country"] = address?.country
                        // print(self.posts[i])
                        downloadGroup.leave()
                    } else {
                        downloadGroup.leave()
                    }
                })
            }
            
            // 2
            downloadGroup.notify(queue: DispatchQueue.main) {
                print("post location done")
                // save data
                let postFileUrl = self.directory.getURL("posts-location.json")
                do {
                    let data = try JSONSerialization.data(withJSONObject: self.posts, options: [])
                    try data.write(to: postFileUrl!, options: [])
                } catch {
                    print(error)
                }
                
            }
            
        } catch {
            print(error)
        }
        
     }
    
    
    @IBAction func getPostJsonDataTapped(_ sender: Any) {
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonParsed = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                if let jsonResult = jsonParsed as? Array<Dictionary<String, AnyObject>> {
                    print(jsonResult.count)
                    
                    // init data
                    for table in jsonResult {
                        if let tableName = table["name"] {
                            
                            if (tableName as! String == "locations") {
                                let jsonLocations = table["data"] as? Array<Dictionary<String, AnyObject>>
                                
                                //for l in 0..<5 {
                                for l in 0..<jsonLocations!.count {
                                    let data = [ "id":(jsonLocations?[l]["id"])!, "address":(jsonLocations?[l]["locations_name"])!, "lat":(jsonLocations?[l]["lat"])!, "lag":(jsonLocations?[l]["lang"])!, "placeId":"0", "latitude":"0", "longitude":"0", "country":"", "city": "", "state":"", "zip":"", "location":"" ] as [String : Any]
                                    locations.append(data)
                                    //print(data)
                                }
                                
                                /*
                                 for l in jsonLocations! {
                                 let data = [ "id":l["id"]!, "address":l["locations_name"]!, "lat":l["lat"]!, "lang":l["lang"]! ] as [String : Any]
                                 locations.append(data)
                                 //print(data)
                                 } */
                            }
                            
                            /*
                             // {"id":"3","user_id":"2","points":"63600"}
                             if tableName as! String == "ranking" {
                             let jsonRanks = table["data"] as? Array<Dictionary<String, AnyObject>>
                             for r in jsonRanks! {
                             let data = [ "id":r["id"]!, "userId":r["user_id"]!, "points":r["points"]! ] as [String : Any]
                             ranks.append(data)
                             }
                             }*/
                            
                            // {"id":"1","interest_name":"Monuments","icon_white":"monuments_white@2x.png","icon_grey":"monuments_greY@2x.png"},
                            if tableName as! String == "interest" {
                                let jsonInterests = table["data"] as? Array<Dictionary<String, AnyObject>>
                                for i in jsonInterests! {
                                    let data: [String: Any] = [ "id":i["id"]!, "interest":i["interest_name"]! ] as [String : Any]
                                    interests.append(data)
                                }
                            }
                            
                            /*
                             // {"id":"1","user_id":"1","interest_id":"8","created_at":"2017-09-07 12:24:37","updated_at":"2017-09-07 12:24:37"},
                             if (tableName as! String == "user_interest") {
                             let jsonUserInterests = table["data"] as? Array<Dictionary<String, AnyObject>>
                             for ui in jsonUserInterests! {
                             
                             let index = interests.index(where: { ($0["id"] as! String) == (ui["interest_id"] as! String) })
                             var interest = ""
                             if index != nil {
                             interest = interests[index!]["interest"] as! String
                             }
                             
                             let data = [ "id":ui["id"]!, "interest":interest, "userId":ui["user_id"]! ] as [String : Any]
                             userInterests.append(data)
                             // print(data)
                             }
                             } */
                            
                            // {"id":"1","username":"bootstrapguru","name":"Admin","about":"Some text about me","avatar_id":null,"cover_id":null,"cover_position":null,"type":"user","location_id":null,"hide_cover":"0","background_id":null,"created_at":"2017-06-30 13:52:46","updated_at":"2017-06-30 13:52:46","deleted_at":null},
                            
                            
                            
                            // {"id":"1","timeline_id":"1","email":"raj88mca@gmail.com","verification_code":"8L3sNTtN41Y1nALCXgF4GvBRhpF9PU","verified":"0","email_verified":"1",
                            // "remember_token":"vXQzm0BJPHos0RdweyQWEBjHkj9fnHrWFBtJGQoBycU5tIwrLfazIwR0fu32","password":"$2y$10$bs3lqfDJJBWwPh1EtdK6fu0DXkq2oJ7OvDWgQBRK6MpULJjCAZmEu",
                            // "balance":"0.00","birthday":"1970-01-01","city":"Hyderabad","country":"India","inspires_you":null,"is_blogger":"0","level":"1",
                            // "user_current_location":null,"designation":null,"hobbies":null,"interests":null,"custom_option1":null,"custom_option2":null,"custom_option3":null,
                            // "custom_option4":null,"gender":"male","active":"1","last_logged":null,"first_log_in":"1","timezone":null,"notification_enable":"1","affiliate_id":null,
                            // "language":null,"facebook_link":null,"twitter_link":null,"dribbble_link":null,"instagram_link":null,"youtube_link":null,"linkedin_link":null,
                            // "created_at":"2017-06-30 13:52:46","updated_at":"2017-06-30 13:52:46","deleted_at":null},
                            /*
                             if (tableName as! String == "users") {
                             let jsonUsers = table["data"] as? Array<Dictionary<String, AnyObject>>
                             // console.log(jsonUsers)
                             
                             for u in jsonUsers! {
                             // assing point to user
                             let index = ranks.index(where: { ($0["userId"] as! String) == (u["id"] as! String) })
                             
                             var point = ""
                             if (index != nil) {
                             
                             // add interests in user
                             var uInterests:[String] = []
                             let foundUserInterests = userInterests.filter { ($0["userId"] as! String) == (u["id"] as! String) }
                             for usr in foundUserInterests {
                             uInterests.append(usr["interest"] as! String)
                             }
                             point = ranks[index!]["points"] as! String
                             /* let email = u["email"] as! String
                             if email.isValid() {} else {
                             print("Email: ", email)
                             } */
                             
                             let index = timelines.index(where: { ($0["id"] as! String) == (u["timeline_id"] as! String) })
                             var name = ""
                             var location = ""
                             var image = ""
                             if index != nil {
                             let lD = timelines[index!]["lId"] as? String
                             if (lD != nil) {
                             location = timelines[index!]["lId"] as! String
                             }
                             name = timelines[index!]["n"] as! String
                             let lA = timelines[index!]["aId"] as? String
                             if (lA != nil) {
                             image = timelines[index!]["aId"] as! String
                             }
                             }
                             
                             // find location and add in post
                             let lIndex = locations.index(where: { ($0["id"] as! String) == (location) })
                             var address = ""
                             var lat = ""
                             var lang = ""
                             if lIndex != nil {
                             address = locations[lIndex!]["address"] as! String
                             lat = locations[lIndex!]["lat"] as! String
                             lang = locations[lIndex!]["lag"] as! String
                             }
                             
                             // add user only those have point > 0
                             let data = [ "id":u["id"]!, "email":u["email"]!, "dob":u["birthday"]!, "city":u["city"]!, "country":u["country"]!, "level":u["level"]!, "active":u["active"]!, "points":point, "interests":uInterests, "udid":"", "image":image, "name":name, "latitude":lat, "longitude":lang, "state":"", "zip":"", "location":address
                             ] as [String : Any]
                             users.append(data)
                             //print(data)
                             
                             }
                             }
                             }
                             if (tableName as! String == "timelines") {
                             let jsonTimeline = table["data"] as? Array<Dictionary<String, AnyObject>>
                             for tl in jsonTimeline! {
                             let data = [ "id":tl["id"]!, "n":tl["name"]!, "lId":tl["location_id"]!, "aId":tl["avatar_id"]! ] as [String : Any]
                             timelines.append(data)
                             //print(data)
                             }
                             }
                             
                             */
                            
                            // {"id":"26231","locations_name":"Donostia Calle 29 Bis Bogoto Bogota Colombia","lat":"4.6158001","lang":"-74.067365","created_at":"2018-07-24 02:12:38","updated_at":"2018-07-24 02:12:38"},
                            
                            // {"id":"1","username":"bootstrapguru","name":"Admin","about":"Some text about me","avatar_id":null,"cover_id":null,"cover_position":null,"type":"user","location_id":null,"hide_cover":"0","background_id":null,"created_at":"2017-06-30 13:52:46","updated_at":"2017-06-30 13:52:46","deleted_at":null},
                            if (tableName as! String == "timelines") {
                                let jsonTimeline = table["data"] as? Array<Dictionary<String, AnyObject>>
                                for tl in jsonTimeline! {
                                    let data = [ "id":tl["id"]!, "n":tl["name"]!, "lId":tl["location_id"]!, "cId":tl["cover_id"]!] as [String : Any]
                                    timelines.append(data)
                                    //print(data)
                                }
                            }
                            
                            
                            // {"id":"1","title":"DSC02685.JPG","type":"image","source":"2017-06-30-15-19-19DSC02685.JPG","created_at":"2017-06-30 14:49:20","updated_at":"2017-06-30 14:49:20","deleted_at":null},
                            if (tableName as! String == "media") {
                                let jsonImages = table["data"] as? Array<Dictionary<String, AnyObject>>
                                for m in jsonImages! {
                                    let data = [ "id":m["id"]!, "title":m["title"]!, "source":m["source"]! ] as [String : Any]
                                    medias.append(data)
                                    //print(data)
                                }
                            }
                            
                            // {"id":"23","post_id":"43","media_id":"473"},
                            if (tableName as! String == "post_media") {
                                let jsonPostMedia = table["data"] as? Array<Dictionary<String, AnyObject>>
                                for pm in jsonPostMedia! {
                                    
                                    // find source and add in posted media
                                    let index = medias.index(where: { ($0["id"] as! String) == (pm["media_id"] as! String) })
                                    var source = ""
                                    if index != nil {
                                        source = medias[index!]["source"] as! String
                                    }
                                    
                                    let data = [ "id":pm["id"]!, "postId":pm["post_id"]!, "source":source ] as [String : Any]
                                    postMedias.append(data)
                                    //print(data)
                                }
                            }
                            
                            
                            // {"id":"1","post_id":"32","interest_id":"14","created_at":"2017-10-28 23:27:37","updated_at":"2017-10-28 23:27:37","deleted_at":null}
                            if (tableName as! String == "post_interest") {
                                let jsonPostInterests = table["data"] as? Array<Dictionary<String, AnyObject>>
                                for pi in jsonPostInterests! {
                                    
                                    // find interset and add in user interest
                                    let index = interests.index(where: { ($0["id"] as! String) == (pi["interest_id"] as! String) })
                                    var interest = ""
                                    if index != nil {
                                        interest = interests[index!]["interest"] as! String
                                    }
                                    
                                    let data = [ "id":pi["id"]!, "interest":interest, "postId":pi["post_id"]! ] as [String : Any]
                                    postInterests.append(data)
                                    //print(data)
                                }
                            }
                            
                            // {"id":"1807","title":"The Buffet","description":"description","timeline_id":"472","user_id":"181","active":"1","related_post":null,
                            // "soundcloud_title":null,"soundcloud_id":null,"youtube_title":null,"youtube_video_id":null,"location":null,"location_id":"26204",
                            // "type":"0","total_saved_share":"1","created_at":"2018-07-20 02:03:37","updated_at":"2018-07-21 21:08:14","deleted_at":null,"shared_post_id":null},
                            if (tableName as! String == "posts") {
                                let jsonPosts = table["data"] as? Array<Dictionary<String, AnyObject>>
                                for p in jsonPosts! {
                                    
                                    // add images in post
                                    var pictures:[String] = []
                                    let fondPostMedia = postMedias.filter { ($0["postId"] as! String) == (p["id"] as! String) }
                                    for media in fondPostMedia {
                                        pictures.append(media["source"] as! String)
                                    }
                                    
                                    // find category and add in post
                                    let pIndex = postCategories.index(where: { ($0["postId"] as! String) == (p["id"] as! String) })
                                    var category = ""
                                    if pIndex != nil {
                                        category = postCategories[pIndex!]["category"] as! String
                                    }
                                    
                                    // find location and add in post
                                    let lIndex = locations.index(where: { ($0["id"] as! String) == (p["location_id"] as! String) })
                                    var address = ""
                                    var lat = ""
                                    var lang = ""
                                    var locationId = ""
                                    if lIndex != nil {
                                        locationId = locations[lIndex!]["id"] as! String
                                        address = locations[lIndex!]["address"] as! String
                                        lat = locations[lIndex!]["lat"] as! String
                                        lang = locations[lIndex!]["lag"] as! String
                                    }
                                    
                                    // add interests in post
                                    var pInterests:[String] = []
                                    let foundPostInterests = postInterests.filter { ($0["postId"] as! String) == (p["id"] as! String) }
                                    for usr in foundPostInterests {
                                        pInterests.append(usr["interest"] as! String)
                                    }
                                    
                                    // find user and add in post
                                    let uIndex = users.index(where: { ($0["id"] as! String) == (p["user_id"] as! String) })
                                    var userName = ""
                                    var udid = ""
                                    if uIndex != nil {
                                        userName = users[uIndex!]["name"] as! String
                                        udid = users[uIndex!]["udid"] as! String
                                    }
                                    
                                    let index = timelines.index(where: { ($0["id"] as! String) == (p["timeline_id"] as! String) })
                                    var cname = ""
                                    var source = ""

                                    var cityaddress = ""
                                    var citylat = ""
                                    var citylang = ""
                                    var citylocationId = ""
                                    
                                    if index != nil {
                                        cname = timelines[index!]["n"] as! String

                                        let clD = timelines[index!]["cId"] as? String
                                        if (clD != nil) {
                                            // find source and add in posted media
                                            let index = medias.index(where: { ($0["id"] as! String) == clD })
                                            if index != nil {
                                                source = medias[index!]["source"] as! String
                                            }
                                        }
                                        
                                        // find location and add in post
                                        let llD = timelines[index!]["lId"] as? String

                                        let lIndex = locations.index(where: { ($0["id"] as! String) == llD })
                                        
                                        if lIndex != nil {
                                            citylocationId = locations[lIndex!]["id"] as! String
                                            cityaddress = locations[lIndex!]["address"] as! String
                                            citylat = locations[lIndex!]["lat"] as! String
                                            citylang = locations[lIndex!]["lag"] as! String
                                        }
                                        
                                        
                                    }
                                    
                                    let data = [ "id":p["id"]!, "title":p["title"]!, "description":p["description"]!, "userId":p["user_id"]!, "address":address, "lat":lat, "lag":lang, "images":pictures, "category":category, "interests":pInterests, "udid": udid, "placeId":"0", "latitude":"0", "longitude":"0", "country":"", "city": "", "state":"", "zip":"", "location":"", "locationId":locationId, "name":userName, "cityName":cname, "cityImage": source, "citylocationId":citylocationId,  "cityaddress":cityaddress, "citylat":citylat, "citylang":citylang ] as [String : Any]
                                    posts.append(data)
                                    // print(data)
                                }
                            }
                            
                            // {"id":"1","name":"Airport","description":"description about Airport","parent_id":"1","active":"0","created_at":"2017-06-30 13:52:46","updated_at":"2017-06-30 13:52:46","deleted_at":null},
                            if (tableName as! String == "categories") {
                                let jsonCategories = table["data"] as? Array<Dictionary<String, AnyObject>>
                                for c in jsonCategories! {
                                    let data = [ "id":c["id"]!, "name":c["name"]! ] as [String : Any]
                                    categories.append(data)
                                    //print(data)
                                }
                            }
                            
                            //{"id":"39","post_id":"426","category_id":"28"}
                            if (tableName as! String == "post_categories") {
                                let jsonPostCategories = table["data"] as? Array<Dictionary<String, AnyObject>>
                                for pc in jsonPostCategories! {
                                    
                                    // find source and add in posted media
                                    let index = categories.index(where: { ($0["id"] as! String) == (pc["category_id"] as! String) })
                                    var category = ""
                                    if index != nil {
                                        category = categories[index!]["name"] as! String
                                    }
                                    
                                    let data = [ "id":pc["id"]!, "postId":pc["post_id"]!, "category":category ] as [String : Any]
                                    postCategories.append(data)
                                    //print(data)
                                }
                            }
                            
                            
                        }
                    }
                    
                    let postFileUrl = self.directory.getURL("json-posts.json")
                    do {
                        let data = try JSONSerialization.data(withJSONObject: self.posts, options: [])
                        try data.write(to: postFileUrl!, options: [])
                        print("post json done")
                    } catch {
                        print(error)
                    }
                    
                }
                
            } catch {
                // handle error
            }
        }
    }
    
    // MARK: - Action
    
    @IBAction func uploadUserImageTapped(_ sender: Any) {
        folderName = "users"
        var dataFiles = directory.getFiles(folderName)
        if let index = dataFiles.index(of: ".DS_Store") {
            dataFiles.remove(at: index)
        }
        
        let dataImages:[UIImage] = directory.getImages(dataFiles, folderName)
        print(dataFiles)
        
        let imageGroup = DispatchGroup()
        for i in 0..<dataImages.count {
            guard let scaledImage = dataImages[i].scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                print("No Image")
                return
            }
            imageGroup.enter()
            print(scaledImage.size)
            self.imageView.image = scaledImage
            
            //let ref = storage.child("\(directory)/\(name).jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            //ref.putData(data, metadata: metadata)
            
            storage.child(folderName).child(dataFiles[i]).putData(data, metadata: metadata) { meta, error in
                print(meta?.dictionaryRepresentation() as Any)
                print(error?.localizedDescription as Any)
                // completion(meta?.downloadURL())
                imageGroup.leave()
            }
        }
        imageGroup.notify(queue: DispatchQueue.main) {
            print("image upload successfully")
        }
        
    }
    
    @IBAction func setFBUserDataTapped(_ sender: Any) {
        let userFileUrl = directory.getURL("users.json")
        do {
            let data = try Data(contentsOf: userFileUrl!, options: [])
            guard let userArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
            
            var profiles:[Profile] = []
            //var emails:[String] = []
            for user in userArray {
                var profile = Profile()
                /*let str = user["dob"] as? String
                 print(str as? String)
                 let date = dateFormatter.date(from: str!)
                 profile.dob = date )*/
                let point = user["points"] as! String
                profile.points = Int(point) ?? 0
                profile.id = user["udid"] as? String
                profile.interests = user["interests"] as! [String]
                profile.email = user["email"] as! String
                profile.name = user["name"] as! String
                profile.password = user["email"] as! String
                profile.image = user["image"] as! String
                profiles.append(profile)
                //emails.append(profile.email)
            }
            //print(emails)
            
            let group = DispatchGroup()
            for i in 0..<profiles.count {
                group.enter()
                let profile = profiles[i]
                self.db.collection("users").document(profile.id!).setData(profile.representation) { err in
                    if let err = err {
                        print("ID:\(profile.id!), Error: \(err.localizedDescription)")
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                print("user save successfully")
            }
            
            
        } catch {
            print(error)
        }
    }
    
    
    
    
    /*
     func saveImageDocumentDirectory(image: UIImage, imageName: String) {
     let fileManager = FileManager.default
     let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("yourProjectImages")
     if !fileManager.fileExists(atPath: path) {
     try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
     }
     let url = NSURL(string: path)
     let imagePath = url!.appendingPathComponent(imageName)
     let urlString: String = imagePath!.absoluteString
     let imageData = UIImageJPEGRepresentation(image, 0.5)
     //let imageData = UIImagePNGRepresentation(image)
     fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
     }
     
     func saveImage(imageName: String){
     let fileManager = FileManager.default
     //get the image path
     let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
     //get the image we took with camera
     let image = imageView.image!
     //get the PNG data for this image
     let data = image.pngData()
     //store it in the document directory
     fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
     }
     
     
     let imageName = "some_image_name.jpg"
     let imageURL = FIRStorage.storage().reference(forURL: "gs://fir-blog-b00c1.appspot.com").child(imageName)
     
     imageURL.downloadURL(completion: { (url, error) in
     
     if error != nil {
     print(error?.localizedDescription)
     return
     }
     
     URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
     
     if error != nil {
     print(error)
     return
     }
     
     guard let imageData = UIImage(data: data!) else { return }
     
     DispatchQueue.main.async {
     self.imageView.image = imageData
     }
     
     }).resume()
     
     })
     
     */
    
    // MARK: - Photo mothods
    
    // photoAction
    @IBAction func photoTapped(_ sender: Any) {
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
        // photoCell?.activityIndicator.isHidden = true
        
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
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Helpers
    
    
    private func sendPhoto(_ image: UIImage) {
        
        uploadImage(image, to: "", of: "") { [weak self] url in
            guard let `self` = self else {
                return
            }
            
            guard let url = url else {
                return
            }
            
            //   var message = Message(user: self.user, image: image)
            //   message.downloadURL = url
            
            //   self.save(message)
            //   self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func uploadImage(_ image: UIImage, to folder: String, of name: String, completion: @escaping (URL?) -> Void) {
        
        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
            completion(nil)
            return
        }
        print(scaledImage.size)
        self.imageView.image = scaledImage
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        
    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: imageData))
        }
    }
    
}


// MARK: - UIImagePickerControllerDelegate

extension RemoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let asset = info[.phAsset] as? PHAsset {
            let size = CGSize(width: 1000, height: 1000)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { result, info in
                guard let image = result else {
                    return
                }
                // self.imageView.image = image
                self.sendPhoto(image)
            }
        } else if let image = info[.originalImage] as? UIImage {
            // self.imageView.image = image
            sendPhoto(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

 */
