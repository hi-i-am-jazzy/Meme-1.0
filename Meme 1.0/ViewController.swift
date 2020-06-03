//
//  ViewController.swift
//  Meme 1.0
//
//  Created by Jazmine Rodriguez on 6/2/20.
//  Copyright © 2020 Jazmine Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    
    let memeTextAttributes = [
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -3.0
    ] as [NSAttributedString.Key : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
    
        // top text field
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        topTextField.textAlignment = NSTextAlignment.center;
        
        // bottom text field
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = NSTextAlignment.center;
        
        // share button
        if (pickedImageView.image == nil) {
            shareButton.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe
        unsubscribeFromKeyboardNotifications()
    }
    
    func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func dismissViewController(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // Functions to move the keyboard
    func subscribeToKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: keyboardWillShow)
        
        center.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: keyboardWillHide)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Picking Images
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImage(sourceType: .camera)
    }
    
    @IBAction func pickImageFromAlbum(sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
    
    func pickImage(sourceType:UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            pickedImageView.image = pickedImage
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Text Field Delegate
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string.uppercased()) as NSString
        textField.text = String(newText)
        return false
    }
    
    // Sharing the Meme
    @IBAction func shareButtonAction(_ sender: Any) {
        print("ShareButtonAction")
        shareMeme(sender: sender);
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        pickedImageView.image = UIImage()
    }
    
    func shareMeme(sender: Any) {
        print("shareMeme")
        let _ = Meme(topText:topTextField.text!, bottomText:bottomTextField.text!, originalImage:pickedImageView.image!, memedImage:generateMemedImage())
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // setting up dismissal of the activity view once the meme is successfully shared:
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        toolBar.isHidden = true
        navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolBar.isHidden = false
        navigationBar.isHidden = false
        
        return memedImage
    }
}
