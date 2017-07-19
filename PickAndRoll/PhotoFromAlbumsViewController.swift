//
//  PhotoFromAlbumsViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 05/07/17.
//  Copyright © 2017 CISPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


class PhotoFromAlbumsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var test = [UIImage]()
    var imageArrayLength = 0
    
    var imagesArryFolder = [String]()
    var bigtitle: UIImage!
    var URL_IMAGES = ""
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    //  var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myUserId = FIRAuth.auth()!.currentUser!.uid
        print("myuserd id is-->\(myUserId)")
        
        
        print("FOLDER ARRAY -->\(imagesArryFolder.count) and \(URL_IMAGES)")
        
        self.imageArrayLength = self.imagesArryFolder.count
        
        print("imageArrayLength is --\(self.imageArrayLength)")
        
        
//        if(self.imageArrayLength == 0){
//            print("No photos")
//        }
//        else{
//            
//            for i in 0...self.imageArrayLength-1 {
//                
//                if let url = NSURL(string: self.imagesArryFolder[i] ) {
//                    
//                    if let imageData = NSData(contentsOf: url as URL) {
//                        let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
//                        let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
//                        let dataImage = UIImage(data: data as Data)
//                        self.bigtitle = dataImage
//                        self.test.append(self.bigtitle)
//                        
//                        do {
//                            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                            
//                            let fileURL = documentsURL.appendingPathComponent("\(String(i)).png")
//                            if let pngImageData = UIImagePNGRepresentation(dataImage!) {
//                                try pngImageData.write(to: fileURL, options: .atomic)
//                            }
//                        } catch { }
//                    }
//                    
//                }
//                
//            }
//        }
//        
        
        
    }
    
    
    //this function is fetching the json from URL
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArryFolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.allowsMultipleSelection = true
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        //   cell.imgImage.image = imageName[indexPath.row]
        print(indexPath.row)
       
        cell.lblName.isHidden = true
        
                for i in 0...self.imagesArryFolder.count-1 {
                    print("test")
                    if let imageUrl = URL(string: self.imagesArryFolder[i]) {
                        URLSession.shared.dataTask(with: URLRequest(url: imageUrl)) { (data, response, error) in
                            if let data = data {
                                DispatchQueue.main.sync {
                                    cell.imgImage.image = UIImage(data: data)
        
                                }
                            }
                            }.resume()
        
                    }
                }
        
        

       // cell.imgImage.image = self.test[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 1
        
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        //        var imageName = [UIImage(named: "1"),UIImage(named: "2"),]
        //        var nameArray = ["name 1","name 2",]
        //
        //
        //
        //        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        //        desCV.getImage = imageName[indexPath.row]!
        //        desCV.getName = nameArray[indexPath.row]
        //        self.navigationController?.pushViewController(desCV, animated: true)
        //
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.green
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.white
    }
    
}
