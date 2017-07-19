//
//  MessageViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 16/06/17.
//  Copyright © 2017 CISPL. All rights reserved.

import UIKit

class MessageViewController: UIViewController,UINavigationBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var menu: UIBarButtonItem!
    
    // Properties
    var imagesDirectoryPath:String!
    var images:[UIImage]!
    var titles:[String]!
    
//    func elcImagePickerController(_ picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [Any]!) {
//               print("selected--\(info)")
//    
//    }
    
//    var picker = ELCImagePickerController(imagePicker: ())
//    /**
//     * Called when image selection was cancelled, by tapping the 'Cancel' BarButtonItem.
//     */
//    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!) {
//        
//        
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        revealViewController().rearViewRevealWidth = 200
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createFolderTapped(_ sender: Any) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print("saved path is-->\(paths)")
        // Get the Document directory path
        let documentDirectorPath:String = paths[0]
        // Create a new path for the new images folder
        imagesDirectoryPath = documentDirectorPath + "/Create folder"
        var objcBool:ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: imagesDirectoryPath, isDirectory: &objcBool)
        // If the folder with the given path doesn't exist already, create it
        if isExist == false{
            do{
                try FileManager.default.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Something went wrong while creating a new folder")
            }
        }
        
////        picker?.maximumImagesCount = 5
////        picker?.imagePickerDelegate = self
////
//        self.present(picker!, animated: true, completion: nil)
//        
    }
    
    
    
    
    
}
