//
//  UsersListViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 06/07/17.
//  Copyright © 2017 CISPL. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class UsersListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let CHAT_SEGUE = "ChatSegue"
    //  var names = [String]()
    var names = [String]()
    var imagesArryFolder = [String]()
    var folderIndex = ""
    var profileImages = [UIImage]()
    var arrayOfUid = [String]()
    var username = ""
    var imageName = [UIImage(named: "home"),UIImage(named: "profile"),UIImage(named: "map")]
    var responseArraySize = 0
    var userId = ""
    var imagesFromFolder = [String]()
    var selectedUserIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myUserId = FIRAuth.auth()!.currentUser!.uid
        
        
        
        userId = myUserId
        print("folder index is--\(folderIndex)")
        print("myuserd id is-->\(myUserId)")
        print("imagesFromFolder----->>>\(imagesFromFolder.count)")
        //creating a NSURL
        let url = NSURL(string: "https://pickandroll-e0897.firebaseio.com/Users.json")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                
                self.arrayOfUid = (jsonObj!.allKeys) as? NSArray as! [String]
                print("arrayOfUid is-->\(self.arrayOfUid)")
                let newArray = (jsonObj?.allValues)! as? NSArray
                print("array is-->\(newArray)")
                
                self.responseArraySize = (newArray?.count)!
                
                for index in 0...self.responseArraySize-1 {
                    
                    let name:String? = (newArray?[index] as AnyObject).value(forKey: "Name") as? String
                    let profileImageUrl = (newArray?[index] as AnyObject).value(forKey: "profileImageUrl") as? String
                    print("name is:\(name!)")
                    self.username = name!
                    self.imagesArryFolder.append(profileImageUrl!)
                    self.names.append(self.username)
                }
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                    //it will show the names to label
                    
                    print(self.names.count)
                    
                })
                
                DispatchQueue.main.async(execute: {
                    for i in 0...self.imagesArryFolder.count-1 {
                        
                        if let url = NSURL(string: self.imagesArryFolder[i] ) {
                            if let imageData = NSData(contentsOf: url as URL) {
                                let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                                let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
                                let dataImage = UIImage(data: data as Data)
                                //self.profileImages.append(dataImage!)
                                self.imageName.append(dataImage)
                            }
                        }
                    }
                    self.tableView.reloadData()
                })
                
            }
        }).resume()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.photo.image = imageName[indexPath.row]
        print("count in view : \(self.names.count)")
        cell.name.text = self.names[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // performSegue(withIdentifier: CHAT_SEGUE, sender: nil)
        print(self.imagesFromFolder.count)
        selectedUserIndex = indexPath.row
        insertImagesToDB()
        print("array uid is : \(arrayOfUid[indexPath.row])")
        let myAlert = UIAlertController(title: "Share Album", message: "Album shared", preferredStyle:UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction);
        self.present(myAlert,animated:true,completion:nil);
    }
    
    func insertImagesToDB(){
        var ref: FIRDatabaseReference!
        var ref2: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref2 = ref.child("Files").child(arrayOfUid[selectedUserIndex])
        for i in 0...self.imagesFromFolder.count-1 {
            
            var folderImages1 = userId.appending(String(folderIndex))
            
          var folderImages =   String(folderIndex)!.appending(userId)
            print("folderimages are-->\(folderImages) and \(folderImages1)")
            let imageNumber = String(format:"%@%d", folderImages, i)
            
            var imageName = imagesFromFolder[i]
            print("imagedetails is-->\(imageNumber) --- \(imageName)")
            
            ref2.child(imageNumber).setValue(imageName)
            
            
        }
        
        
    }
    
    
}
