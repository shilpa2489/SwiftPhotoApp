//
//  DisplayContactsViewController.swift
//  PickAndRoll
//
//  Created by Shilpa-CISPL on 22/06/17.
//  Copyright © 2017 CISPL. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class DisplayContactsViewController: UIViewController,CNContactPickerDelegate {

    @IBOutlet weak var lblDetails: UILabel!
    var allPhoneNumbers = [String]()
    var fbPhoneNumbers = [String]()
    var fbPhoneNumbersSize = 0
    let URL_PHONE_NUMBERS = "https://pickandroll-e0897.firebaseio.com/Users.json";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getJsonFromUrl()
        let contactStore = CNContactStore()
        let keys = [CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey, CNContactPhoneNumbersKey]
        let request1 = CNContactFetchRequest(keysToFetch: keys  as [CNKeyDescriptor])
        
        try? contactStore.enumerateContacts(with: request1) { (contact, error) in
            for phone in contact.phoneNumbers {
                // Whatever you want to do with it
              //  print((contact.phoneNumbers[phone].value ).value(forKey: "digits") as! String)
                
                print("numbers are-->\((phone.value.value(forKey: "digits"))!)")
                self.allPhoneNumbers.append((phone.value.value(forKey: "digits"))! as! String)
                print("Total phone number count is-->\(self.allPhoneNumbers.count)")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnSelectContact(_ sender: Any) {
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == CNAuthorizationStatus.notDetermined {
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: entityType, completionHandler: { (success,nil) in
                
                if success {
                    
                    self.openContacts()
                }
                else {
                    print("Not authorized")
                }
            })
        }
        else if authStatus == CNAuthorizationStatus.authorized {
            self.openContacts()
        }
    }
    func openContacts() {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker,animated: true,completion: nil)
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let fullName = "\(contact.givenName) \(contact.familyName)"
        self.lblDetails.text = "Name : \(fullName)"
        print(contact.phoneNumbers)
        
       print((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)
    }
    
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        //creating a NSURL
        let url = NSURL(string: URL_PHONE_NUMBERS)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                let newArray = (jsonObj?.allValues)! as? NSArray
                
                self.fbPhoneNumbersSize = (newArray?.count)!
                
                for index in 0...self.fbPhoneNumbersSize-1 {
                    
                    let PhoneNumber:String? = (newArray?[index] as AnyObject).value(forKey: "PhoneNumber") as? String
                    self.fbPhoneNumbers.append(PhoneNumber!)
                    print("TotalfbArrayValues are--> \(self.fbPhoneNumbers.count) ")
                    
                }
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                    //it will show the names to label
                    // self.showNames()
                    
                })
                DispatchQueue.main.async(execute: {
                    self.fbPhoneNumbersSize = (newArray?.count)!
                    print("responseArraySizeDispatch is -->\(self.fbPhoneNumbersSize)")
                     for j in 0...self.fbPhoneNumbersSize-1 {
                        
                        if(self.allPhoneNumbers.contains(self.fbPhoneNumbers[j])) {
                            print("Matching Phone Numbers")
                           
                        }
                    }
                })
                
            }
        }).resume()
    }
}
