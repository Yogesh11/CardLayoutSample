//
//  ViewController.swift
//  CollectionViewSample
//
//  Created by Yogesh on 10/18/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionLayout: UICollectionView!
    var models : [DataModel] = [DataModel]()
    private var customLayout: CustomLayout? = nil
    fileprivate var longPressGesture: UILongPressGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let layout = collectionLayout?.collectionViewLayout as? CustomLayout {
            customLayout = layout
            customLayout?.delegate = self
        }
      ///  collectionLayout.dropDelegate = self
       // collectionLayout.dragDelegate = self
        //view.addInteraction(UIDropInteraction(delegate: self))
       // collectionLayout.dragDelegate = self
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionLayout.addGestureRecognizer(longPressGesture)


        let messages = ["My life is my message" ,
                        "Not how long, but how well you have lived is the main thing." ,
                        "I love those who can smile in trouble",
                        "Time means a lot to me because, you see, I, too, am also a learner and am often lost in the joy of forever developing and simplifying. If you love life, don’t waste time, for time is what life is made up of" ,
                        "Life is what happens when you’re busy making other plans",
                         "Very little is needed to make a happy life; it is all within yourself, in your way of thinking.",
                         "It is better to be hated for what you are than to be loved for what you are not.",
                         "Dost thou love life? Then do not squander time, for that is the stuff life is made of" ,
                         "Life is like playing a violin in public and learning the instrument as one goes on" ,
                         "In the end, it’s not the years in your life that count. It’s the life in your years.",
                         "You’ve gotta dance like there’s nobody watching.",
                         "Believe that life is worth living and your belief will help create the fact.",
                         "Do not take life too seriously. You will never get out of it alive. ",
                         "Do stuff. Be clenched, curious. Not waiting for inspiration’s shove or society’s kiss on your forehead. Pay attention. It’s all about paying attention. Attention is vitality. It connects you with others. It makes you eager."
                         ]
        for message in messages {
            let model = DataModel()
            model.makeModel(title: message)
            models.append(model)
        }
         prepareUIAccordingToMode(true)
    }

    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {

        case .began:
            guard let selectedIndexPath = collectionLayout.indexPathForItem(at: gesture.location(in: collectionLayout)) else {
                break
            }
            collectionLayout.beginInteractiveMovementForItem(at: selectedIndexPath)

        case .changed:
            collectionLayout.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
           //  print("selectedIndex Changed: \(selectedIndexPath.row)")
        case .ended:
//            guard let selectedIndexPath = collectionLayout.indexPathForItem(at: gesture.location(in: collectionLayout)) else {
//                break
//            }
            collectionLayout.endInteractiveMovement()
          //  print("selectedIndex Changed: \(selectedIndexPath.row)")
            
        default:
            collectionLayout.cancelInteractiveMovement()
        }
    }


    fileprivate func calculateHeight(str : String, width : CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = str.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
        return ceil(boundingBox.height)
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let model = models.remove(at: sourceIndexPath.item)
        models.insert(model, at: destinationIndexPath.item)
        prepareUIAccordingToMode()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? TitleCell
        let model = models[indexPath.row]
        collectionViewCell?.displayContent(text: model.title)
        collectionViewCell?.backgroundColor = model.color
        return collectionViewCell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getSize(index: indexPath.row)
    }

    private func getSize(index : Int)-> CGSize{
        let orientation = UIApplication.shared.statusBarOrientation
        let model = models[index]
        var width : CGFloat  = 0
        if(orientation == .landscapeLeft || orientation == .landscapeRight) {
            width = (self.view.frame.size.width)/3 - 40
        }else{
            width = (self.view.frame.size.width - 16)/2
        }
        return CGSize(width: width, height: calculateHeight(str: model.title, width: (width - 32)) + 32)
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.prepareUIAccordingToMode()
        })

    }

    func prepareUIAccordingToMode(_ isFromInitialState : Bool = false){
        let orientation = UIApplication.shared.statusBarOrientation
        if(orientation == .landscapeLeft || orientation == .landscapeRight){
            customLayout?.prepareLandScapeMode(isFromInitialState)
        } else{
            customLayout?.preparePotraitMode(isFromInitialState)
        }
        collectionLayout.reloadData()
    }

}



extension ViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightAtIndexPath indexPath:IndexPath) -> CGFloat {

        return getSize(index: indexPath.row).height
    }
}

