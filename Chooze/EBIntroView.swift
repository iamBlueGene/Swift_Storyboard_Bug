//
//  EBIntroView.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/26/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit

private var _myIntroView = EBIntroView()

class EBIntroView: NSObject, EBIntroPageProtocol, UIScrollViewDelegate {
    
    var window:UIWindow?
    var contentView:UIView
    var scrollView:UIScrollView
    var pageControl:UIPageControl
    var howManyPages = 0
    private  var didFinishIntroClosure: (() -> ())?

    
    class var sharedInstance : EBIntroView {
    return _myIntroView
    }
    
    override init() {
        self.window = UIWindow(frame: UIApplication.sharedApplication().keyWindow.frame)
        self.window!.windowLevel = UIWindowLevelAlert
        
        self.pageControl = UIPageControl(frame: CGRectMake(0, 0, 200, 50))
        
        self.contentView = UIView(frame: self.window!.frame)
        
        self.scrollView = UIScrollView(frame: self.contentView.frame)
        self.scrollView.bounces = false
        self.scrollView.pagingEnabled = true
        
        self.contentView.addSubview(self.scrollView)
        self.contentView.addSubview(self.pageControl)
        self.window!.addSubview(self.contentView)
    }
    
    func show(finishClosure :() -> ()) {
        self.didFinishIntroClosure = finishClosure
        self.createIntroPages()
        self.createPageControl()
        self.scrollView.delegate = self
        self.window!.makeKeyAndVisible()
    }
    
    private func createIntroPages() {
        var startX:CGFloat = 0
        let infoArray = EBFileReader.getIntroInfo()
        self.howManyPages = infoArray.count
        
        for (index, info) in enumerate(infoArray) {
            let imageName = "introImage" + String(index + 1)
            var introPage = EBIntroPage(imageName: imageName, infoText: info, delegate: self, frame: self.window!.frame)
            //introPage.frame = CGRectMake(startX, 0, introPage.frame.width, introPage.frame.height)
            introPage.frame.origin.x = startX
            
            self.scrollView.addSubview(introPage)
            
            startX += self.window!.frame.width
            
            if (index + 1) == infoArray.count {
                introPage.turnOnDoneButton()
            }
            
        }
        
        self.scrollView.contentSize = CGSize(width: startX, height: self.window!.frame.height)
    }
    
    private func createPageControl() {
        self.pageControl.numberOfPages = self.howManyPages
        self.pageControl.center = CGPointMake(self.window!.center.x, (self.window!.frame.height * 0.88) + 15)
        self.pageControl.currentPage = 0
        self.pageControl.backgroundColor = UIColor.clearColor()
        self.pageControl.pageIndicatorTintColor = UIColor.lightTextColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        self.contentView.bringSubviewToFront(self.pageControl)
    }
    
   
    // MARK: - EBIntroPageProtocol
    func introPageDone() {
        self.window = nil
        self.didFinishIntroClosure!()
    }
    
    // MARK: UISCrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let newOffset = self.scrollView.contentOffset.x
        let newPage = Int((newOffset/self.scrollView.frame.size.width))
        self.pageControl.currentPage = newPage
    }
    
    
    
    
    
   
}
