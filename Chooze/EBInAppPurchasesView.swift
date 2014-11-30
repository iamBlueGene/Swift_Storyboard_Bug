//
//  EBInAppPurchasesView.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 11/20/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

class EBInAppPurchasesView: UIView, SKPaymentTransactionObserver {

    @IBOutlet var contentView: UIView!
    
    override init() {
        super.init(frame: CGRectMake(0, 0, 250, 300))
        ChoozeUtils.loadViewsFromBundle(self.classForCoder, classOwner: self)
        self.addSubview(self.contentView)
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        self.contentView.frame = self.frame
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.removeFromSuperview()
    }
    @IBAction func buyIapButtonPressed(sender: AnyObject) {
        PFPurchase.buyProduct("io.chooze.unlimited", block: { (error) -> Void in
            if error != nil {
                println(error)
            } else {
                println("Bought")
            }
        })
       //IAPManager.sharedInstance.buyInfiniteTests()
    }
    
    @IBAction func inviteFriends(sender: AnyObject) {
        EBFacebookService.sharedInstance.inviteFacebookFriends()
    }
    
    // required by protocol
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        println("paymentQueueRestoreCompletedTransactionsFinished");
    }
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!) {
        println("paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!) ");
    }
    func paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!) {
        println("paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!) ");
    }
    func paymentQueue(queue: SKPaymentQueue!, updatedDownloads downloads: [AnyObject]!) {
        println("paymentQueue(queue: SKPaymentQueue!, updatedDownloads downloads: [AnyObject]!) ");
    }
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        println("paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)");
    }
    
}
