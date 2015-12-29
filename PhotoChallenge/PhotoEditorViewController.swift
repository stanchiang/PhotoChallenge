//
//  PhotoEditorViewController.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/28/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

class PhotoEditorViewController: UIViewController {
	
	@IBOutlet weak var imageContainerView: UIView!
	@IBOutlet weak var createPhotoPostButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var addTextButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	
	var photo:UIImage?
	var textField:UITextField? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.addTapGestureRecognizer()
	}
	
	override func viewDidAppear(animated: Bool) {

		super.viewDidAppear(animated)
		
		imageView.image = photo
		
		if photo == nil {
			self.showPhotoEditorControls(false)
		} else {
			self.showPhotoEditorControls(true)
		}
	}
	
	func showPhotoEditorControls(shouldShow:Bool) {
		imageContainerView.hidden = !shouldShow
		addTextButton.hidden = !shouldShow
		saveButton.hidden = !shouldShow
		createPhotoPostButton.hidden = shouldShow
	}
	
	func addTapGestureRecognizer() {
		let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		tapRecognizer.numberOfTapsRequired = 1
		tapRecognizer.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tapRecognizer)
	}
	
	func dismissKeyboard() {
		self.view.endEditing(true)
	}
	
	@IBAction func addTextFieldButton(sender: UIButton) {
		
		if textField == nil {
			textField = UITextField(frame: CGRectMake(8.0, imageContainerView.frame.size.height / 2.0 - 40.0, self.imageContainerView.frame.size.width, 40.0))
			textField!.delegate = self
			textField!.borderStyle = .None
			textField!.returnKeyType = .Done
			
			imageContainerView.addSubview(textField!)
		}
		
		textField!.becomeFirstResponder()
	}
	
	@IBAction func saveButtonTapped(sender: UIButton) {

		UIImageWriteToSavedPhotosAlbum(self.imageFromContainer(), self, "image:hasBeenSavedWithError:contextInfo:", nil)
		self.showPhotoEditorControls(false)
		photo = nil
		textField?.text = nil 
	}
	
	func image(image:UIImage , hasBeenSavedWithError error: NSError , contextInfo:UnsafePointer<Void>) {
		
		if error.code != 0 {
			print("Error occured when saving image with domain: \(error.domain) and userinfo: \(error.userInfo)")
		} else {
			self.showSavedPhotoAlert(image)
		}
	}
	
	func showSavedPhotoAlert(image:UIImage) {
		
		let successAlert = UIAlertController(title: "Successfully Saved", message: "There is a new photo in your library.", preferredStyle: .Alert)
		let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		let shareAction = UIAlertAction(title: "Share", style: .Default, handler: { _ in self.showShareMenu(image)})
		successAlert.addAction(doneAction)
		successAlert.addAction(shareAction)
		
		presentViewController(successAlert, animated: true, completion: nil)
	}
	
	func showShareMenu(image:UIImage) {
		
		let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		presentViewController(activityController, animated: true, completion: nil)
	}
	
	func imageFromContainer() -> UIImage {
		
		UIGraphicsBeginImageContextWithOptions(imageContainerView.frame.size, true, 0)
		imageContainerView.drawViewHierarchyInRect(imageContainerView.bounds, afterScreenUpdates: true)
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return result
	}
	
}

extension PhotoEditorViewController : UITextFieldDelegate {
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
	
		textField.resignFirstResponder()
		return true
	}
}

extension PhotoEditorViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBAction func showPhotoMenu(sender: UIButton) {
		
		/***
		Create an alertController with no title and no message
		Configure three buttons for the photo menu
		Add the actions to the alertController
		Present the photo menu
		***/
		let photoMenuController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { _ in print("photo menu cancelled")})
		let takePhotoAction = UIAlertAction(title: "Use Camera", style: .Default, handler: { _ in self.useCamera()})
		let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .Default, handler: {_ in self.openPhotoLibrary()})
		
		photoMenuController.addAction(cancelAction)
		photoMenuController.addAction(takePhotoAction)
		photoMenuController.addAction(chooseFromLibraryAction)
		
		presentViewController(photoMenuController, animated: true, completion: nil)
	}
	
	func useCamera() {
		if UIImagePickerController.isSourceTypeAvailable(.Camera) {
			let imagePicker = UIImagePickerController()
			imagePicker.sourceType = .Camera
			imagePicker.delegate = self
			imagePicker.allowsEditing = true
			presentViewController(imagePicker, animated: true, completion: nil)
		}
	}
	
	func openPhotoLibrary() {
		if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
			let imagePicker = UIImagePickerController()
			imagePicker.sourceType = .PhotoLibrary
			imagePicker.delegate = self
			imagePicker.allowsEditing = true
			presentViewController(imagePicker, animated: true, completion: nil)
		}
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		
		dismissViewControllerAnimated(true, completion: nil)
		
		if let newImage = info[UIImagePickerControllerEditedImage] {
			
			photo = newImage as? UIImage
		}
	}
}
