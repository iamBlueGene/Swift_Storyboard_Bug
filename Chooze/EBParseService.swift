//
//  EBParseService.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/26/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBParseService: NSObject {
    
    class func saveInviteToUser(userID :String) {
        //see if such invite already exists
        var checkInviteQuery = PFQuery(className: "InvitesSent")
        checkInviteQuery.whereKey("userSent", equalTo: PFUser.currentUser().objectId)
        checkInviteQuery.whereKey("toUser", equalTo: userID)
        checkInviteQuery.findObjectsInBackgroundWithBlock { (invitesFound, error) -> Void in
            if error != nil {
                println("Error in 'saveInviteToUser', 'checkInviteQuery' \(error.description)")
            }
            else {
                if invitesFound.count == 0 {
                    //add invite
                    var newInvite = PFObject(className: "InvitesSent")
                    newInvite["userSent"] = PFUser.currentUser().objectId
                    newInvite["toUser"] = userID
                    newInvite.saveInBackgroundWithBlock({ (succeded, error) -> Void in
                        if !succeded {
                            // could not save
                            println("Error in 'saveInviteToUser' , 'newInvite' \(error.description)")
                            newInvite.saveEventually()
                        }
                    })
                }
            }
            
        }
    }
    
    class func logInToParse(username: String, password: String, successBlock: ((success: Bool, parseError :NSError?) -> ())) {
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) -> Void in
            if user != nil {
                successBlock(success: true, parseError:nil)
            }
            else {
                successBlock(success: false, parseError: error)
                
            }
        }
    }
    
    class func resetPassword(username: String, completionClosure :((error :NSError?) ->())) {
        PFUser.requestPasswordResetForEmailInBackground(username, block: { (success, error) -> Void in
            if !success {
                completionClosure(error: error)
            } else {
                completionClosure(error: nil)
            }
        })
    }
    
    class func signUpUser(username: String, password: String, completionClosure :((error :NSError?) -> ())) {
        var user = PFUser()
        let uuid = NSUUID.UUID().UUIDString
        user.username = uuid
        user.email = username
        user.password = password
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            if success {
                completionClosure(error: nil)
            }
            else {
                completionClosure(error: error)
            }
        }
    }
   
}
