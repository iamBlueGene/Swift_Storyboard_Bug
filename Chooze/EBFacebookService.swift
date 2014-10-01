//
//  EBFacebookService.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/25/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

private let _myFacebookService = EBFacebookService()

class EBFacebookService: NSObject {
    
    class var sharedInstance : EBFacebookService {
        return _myFacebookService
    }
    
     func inviteFacebookFriends() {
        
        //var params = nil;
        
        FBWebDialogs.presentRequestsDialogModallyWithSession(PFFacebookUtils.session(), message: "Come find a name for your baby", title: "Chooze", parameters: nil) { (result, resultURL, error) -> Void in
            if error != nil {
                ChoozeUtils.showError(error)
            }
            else {
                if result == FBWebDialogResult.DialogNotCompleted {
                    println("User cancelled request")
                }
                else {
                    self.processResult(resultURL)
                }
            }
        }
        
    }
    
    func signInWithFacebook(successBlock :((success :Bool, error :NSError?) -> ())) {
        
        let permissionsArray = ["public_profile", "user_friends", "email"]
        
        PFFacebookUtils.logInWithPermissions(permissionsArray, {
            (user: PFUser!, error: NSError!) -> Void in
            if error != nil {
                successBlock(success: false, error: error)
            }
            if user == nil {
                //user cancelled
                successBlock(success: false, error: nil)
            } else if user.isNew {
                //new user
                successBlock(success: true, error: nil)
            } else {
                //user already logged in once
                successBlock(success: true, error: nil)
            }
        })
    }
    
    // MARK: - Private methods
    
    private func processResult(resultURL :NSURL) {
        let userIDs = self.parseFacebookResultURL(resultURL)
        for userID in userIDs {
            EBParseService.saveInviteToUser(userID)
        }
        
    }
    
    private func parseFacebookResultURL(resultURL :NSURL) -> Array<String> {
        var userIDs = Array<String>()
        if resultURL.absoluteString != nil {
            var urlParts:Array<String> = resultURL.absoluteString!.componentsSeparatedByString("5D=")
            urlParts.removeAtIndex(0) // remove first object
            for userInfo in urlParts {
                let userID = userInfo.componentsSeparatedByString("&to").first
                if userID != nil {
                    userIDs.append(userID!)
                }
            }
        }
        return userIDs
    }
}
