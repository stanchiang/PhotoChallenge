//
//  PhotoLabel.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/29/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

class PhotoLabel: UILabel {
	
	var panRecognizer: UIPanGestureRecognizer?
	var doubleTapRecognizer: UITapGestureRecognizer?
	
	var sizeStage:Int = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		userInteractionEnabled = true
        
		panRecognizer = UIPanGestureRecognizer(target: self, action: "move")
		doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "incrementSizeStage")
		doubleTapRecognizer?.numberOfTapsRequired = 2
        
		self.addGestureRecognizer(panRecognizer!)
		self.addGestureRecognizer(doubleTapRecognizer!)
		
		/***
		Center the text and change the font name, size, and color
		***/
		textAlignment = .Center
		font = UIFont(name: "Futura", size: 20.0)
		textColor = UIColor.whiteColor()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	

	/***
	Panning on the label will drag
	***/
	func move() {
		let translation = panRecognizer?.translationInView(self)
		self.center.x += (translation?.x)!
		self.center.y += (translation?.y)!
		
		panRecognizer?.setTranslation(CGPointZero, inView: self)
	}
	
    /***
     Cycle through different sizes and alignments
    ***/
	func incrementSizeStage() {
		
		sizeStage += 1
		if sizeStage > 3 {
			sizeStage = 0
		}

		switch sizeStage {
			case 0:
				//Center the label and size it similar to textField
				self.frame = CGRectMake(0, 0, (self.superview?.bounds.width)!, 20)
				self.center = (self.superview?.center)!
				self.font = UIFont.systemFontOfSize(18)
				self.numberOfLines = 1
			
			case 1:
				//Increase frame size and font
				let height = (self.superview?.bounds.height)! * 0.7
				self.textAlignment = .Center
				self.frame = CGRectMake(0, 0, (self.superview?.bounds.width)!, height)
				self.center = (self.superview?.center)!
				self.font = UIFont.systemFontOfSize(50)
				self.numberOfLines = 0
			
			case 2:
				//Right align text
				self.textAlignment = .Right
			
			case 3:
				//Left align text
				self.textAlignment = .Left
			default: break
		}
	}
}


























