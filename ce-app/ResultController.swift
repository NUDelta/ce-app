
//
//  ResultController.swift
//  ce-app
//
//  Created by Shannon Nachreiner on 2/21/16.
//  Copyright © 2016 delta. All rights reserved.
//

import UIKit

class ResultController: UICollectionViewController {
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    
    let imageArr: [UIImage] = [UIImage(named: "full_breakfast")!, UIImage(named: "egg_benedict")!, UIImage(named: "hamburger")!, UIImage(named: "white_chocolate_donut")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArr.count
    }
    
    // make a cell for each cell index path
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ResultControllerCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.myLabel.text = self.items[indexPath.item]
        cell.resultImage.image = self.imageArr[indexPath.item]
        //cell.backgroundColor = UIColor.yellowColor() // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
