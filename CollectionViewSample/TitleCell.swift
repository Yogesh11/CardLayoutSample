//
//  TitleCell.swift
//  CollectionViewSample
//
//  Created by Yogesh on 10/18/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class TitleCell:  UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    func displayContent(text : String){
        titleLabel.text = text
    }
}
