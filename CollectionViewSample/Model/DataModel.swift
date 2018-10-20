//
//  DataModel.swift
//  CollectionViewSample
//
//  Created by Yogesh on 10/18/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class DataModel: NSObject {


    var title :String = ""
    var color : UIColor = UIColor.white

    func makeModel(title : String){
        self.title = title
        color = getRandomColor()
    }

    func getRandomColor() -> UIColor{
        let randomRed:CGFloat    = CGFloat(drand48())
        let randomGreen:CGFloat  = CGFloat(drand48())
        let randomBlue:CGFloat   = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
