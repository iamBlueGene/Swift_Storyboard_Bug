//
//  IAPManager.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 11/21/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

private let _myManager = IAPManager()
private let prodcutID1 = "io.chooze.unlimited"

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    class var sharedInstance : IAPManager {
        return _myManager
    }
    
    func buyInfiniteTests(){
        println("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments()) {
            var productID:NSSet = NSSet(object: prodcutID1);
            var productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID);
            productsRequest.delegate = self;
            productsRequest.start();
            println("Fething Products");
        }
        else {
            println("can not make purchases");
        }
    }
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        println("got the request from Apple")
        var count : Int = response.products.count
        if (count>0) {
            var validProducts = response.products
            var validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == prodcutID1) {
                println(validProduct.localizedTitle)
                println(validProduct.localizedDescription)
                println(validProduct.price)
                buyProduct(validProduct);
            } else {
                println(validProduct.productIdentifier)
            }
        } else {
            println("nothing")
        }
    }
    
    func buyProduct(product: SKProduct){
        println("Sending the Payment Request to Apple");
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)    {
        println("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    println("Product Purchased");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as SKPaymentTransaction)
                    break;
                case .Failed:
                    println("Purchased Failed");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as SKPaymentTransaction)
                    break;
                    // case .Restored:
                    //[self restoreTransaction:transaction];
                default:
                    break;
                }
            }
        }
    }

    
    
}
