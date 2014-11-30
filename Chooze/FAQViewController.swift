//
//  FAQViewController.swift
//  Chooze
//
//  Created by Eliyahu Braginskiy on 9/23/14.
//  Copyright (c) 2014 BlueGene. All rights reserved.
//

import UIKit


class FAQViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var questionsArray = EBFileReader.getQuestionsInfo()
    private var answersArray = EBFileReader.getAnswersInfo()
    private var howMuchToAdd:CGFloat = 0
    private var selectedRow = -1
    private let k_CellHeight:CGFloat = 40

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.questionsArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as UITableViewCell
        var questionLabel = cell.contentView.viewWithTag(111) as UILabel
        var question = questionsArray[indexPath.section]
        questionLabel.text = question.uppercaseString
        
        
        var answerLabel = cell.contentView.viewWithTag(555) as UILabel
        answerLabel.text = answersArray[indexPath.section]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as UITableViewCell
        var answerLabel = cell.contentView.viewWithTag(555) as UILabel
        answerLabel.text = answersArray[indexPath.section]
        answerLabel.alpha = 1.0
        
        var questionLabel:UIView  = cell.contentView.viewWithTag(111)!
        questionLabel.alpha = 0.0
        questionLabel.backgroundColor = UIColor.redColor()

        
        var imageView = cell.contentView.viewWithTag(333) as UIImageView
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            let rads = ChoozeUtils.degreesToRadians(90)
            let transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(rads))
            imageView.transform = transform
        })

        cell.layoutIfNeeded()
        
        self.howMuchToAdd = ChoozeUtils.calculateHeightForLabel(answerLabel.text!, font: answerLabel.font, width: questionLabel.frame.size.width)
        
        cell.contentView.backgroundColor = ChoozeUtils.rgbColor(243, greenValue: 243, blueValue: 243)
        self.selectedRow = indexPath.section
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        

    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as UITableViewCell
        
        var answerLabel = cell.contentView.viewWithTag(555) as UILabel
        answerLabel.alpha = 0.0
        
        var imageView = cell.contentView.viewWithTag(333) as UIImageView
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            let rads = ChoozeUtils.degreesToRadians(0)
            let transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(rads))
            imageView.transform = transform
        })
        
        self.howMuchToAdd = 0
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var currentRow = indexPath.section
        
        if currentRow == self.selectedRow {
            return (k_CellHeight + self.howMuchToAdd)
        }
        else {
            return k_CellHeight
        }
    }

}
