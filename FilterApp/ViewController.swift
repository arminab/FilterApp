//
//  ViewController.swift
//  FilterApp
//
//  Created by Armin on 5/22/16.
//  Copyright © 2016 Armin. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedFilter = ""
    var modifier = 0
    
    @IBOutlet weak var contrast: UIButton!
    @IBOutlet weak var grayscale: UIButton!
    @IBOutlet weak var colorInversion: UIButton!
    @IBOutlet weak var brightness: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var filterActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var originalImageLabel: UILabel!

    
    //@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var filteredImageview: UIImageView!
    
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var sliderView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        filterButton.enabled = false
        compareButton.enabled = false
        shareButton.enabled = false
        editButton.enabled = false
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        originalImageLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        originalImageLabel.alpha = 0

        slider.minimumValue = -50
        slider.maximumValue = 50
        slider.continuous = false
        slider.value = 0
        
        filterActivityIndicator.hidesWhenStopped = true
        
        
        sliderView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        contrast.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        contrast.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        contrast.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        grayscale.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        grayscale.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        grayscale.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        colorInversion.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        colorInversion.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        colorInversion.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        brightness.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        brightness.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        brightness.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if ((touches.first) != nil)  {
            if(originalImageView.image != nil){
                if (!compareButton.selected) {
                    hideFilteredImageView()
                    showOriginalImageLabel()
                } else {
                    showFilteredImageView()
                    hideOriginalImageLabel()
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if ((touches.first) != nil) {
            if (filteredImageview.image != nil){
                if (!compareButton.selected) {
                showFilteredImageView()
                hideOriginalImageLabel()
                } else {
                    hideFilteredImageView()
                    showOriginalImageLabel()
                }
            }
        }
    }
    
    
    @IBAction func filters(sender: UIButton) {
        
        if (originalImageView.image != nil){
            slider.enabled = false
            let tempImage = Filter()
            tempImage.image = originalImageView.image
            filterActivityIndicator.startAnimating()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var filteredImage : UIImage?
                switch sender {
                case self.contrast:
                    filteredImage = tempImage.constrast(self.modifier).toUIImage()!
                    self.selectedFilter = "contrast"
                    self.sliderModifier(-25, max: 25)
                case self.grayscale:
                    filteredImage = tempImage.grayscale().toUIImage()!
                    self.selectedFilter = "grayscale"
                case self.brightness:
                    if (self.modifier != 0){
                    filteredImage = tempImage.brightness(self.modifier).toUIImage()!
                    }
                    self.selectedFilter = "brightness"
                    self.sliderModifier(-50, max: 50)
                case self.colorInversion:
                    filteredImage = tempImage.colorInversion().toUIImage()!
                    self.selectedFilter = "colorInversion"
                default: break
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.filteredImageview.image = filteredImage
                    self.showFilteredImageView()
                    self.compareButton.enabled = true
                    self.shareButton.enabled = true
                    self.editButton.enabled = true
                    self.hideOriginalImageLabel()
                    self.filterActivityIndicator.stopAnimating()
                    
                    self.slider.enabled = true
                    switch sender {
                    case self.contrast:
                        self.editButton.enabled = true
                    case self.grayscale:
                        self.editButton.enabled = false
                    case self.brightness:
                        self.editButton.enabled = true
                    case self.colorInversion:
                        self.editButton.enabled = false
                    default: break
                    }
                    
                    if (self.compareButton.selected){
                        self.compareButton.selected = false
                    }
                    
                })
            });
        }
    }
    
    @IBAction func onSlider(sender: UISlider) {
        modifier = Int(sender.value)
        switch selectedFilter {
        case "contrast":
            filters(self.contrast)
        case "brightness":
            filters(self.brightness)
        default:
            break
        }
    }
    
    @IBAction func onEdit(sender: UIButton) {
        if (sender.selected){
            hideSliderView()
            sender.selected = false
        }
        else{
            hideSecondaryMenu()
            showSliderView()
            filterButton.selected = false
            sender.selected = true
            if (self.compareButton.selected){
                onCompare(compareButton)
            }
        }
    }
    
    @IBAction func onCompare(sender: UIButton) {
        if (sender.selected){
            showFilteredImageView()
            hideOriginalImageLabel()
            sender.selected = false
        }
        else{
            hideFilteredImageView()
            showOriginalImageLabel()
            sender.selected = true
            editButton.selected = false
            hideSliderView()
        }
    }
    
    @IBAction func onFilter(sender: UIButton) {
        if sender.selected{
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMeny()
            editButton.selected = false
            hideSliderView()
            sender.selected = true
            thumbnail()
        }
    }
    
    @IBAction func onShare(sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [originalImageView.image!], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    @IBAction func onNewPhoto(sender: UIButton) {
        hideSecondaryMenu()
        filterButton.selected = false
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: {
            action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: {
            action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func sliderModifier(min:Float, max:Float){
        slider.minimumValue = min
        slider.maximumValue = max
        
        
    }
    
    func showCamera(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            filterButton.enabled = true
            filteredImageview.image = nil
            shareButton.enabled = false
            compareButton.enabled = false
            editButton.enabled = false
            
            if (compareButton.selected){
                compareButton.selected = false
            }
            
            if (editButton.selected){
                editButton.selected = false
                hideSliderView()
            }
            
            showOriginalImageLabel()
            originalImageView.image = image
            filteredImageview.image = nil
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func thumbnail(){
        
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(self.contrast.frame.size, true, scale)
        //self.originalImage!.drawInRect(CGRect(origin: CGPointZero, size: self.contrast.frame.size))
        self.originalImageView.image!.drawInRect(CGRect(origin: CGPointZero, size: self.contrast.frame.size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let tempImage = Filter()
        tempImage.image = scaledImage
        
        dispatch_async(dispatch_get_main_queue()) {
            let scaledFilteredImage = tempImage.constrast(self.modifier).toUIImage()!
            self.contrast.setImage(scaledFilteredImage, forState: UIControlState.Normal)
            self.contrast.backgroundColor = UIColor.clearColor()
        }
        dispatch_async(dispatch_get_main_queue()) {
            let scaledFilteredImage = tempImage.grayscale().toUIImage()!
            self.grayscale.setImage(scaledFilteredImage, forState: UIControlState.Normal)
            
            self.grayscale.backgroundColor = UIColor.clearColor()
        }
        dispatch_async(dispatch_get_main_queue()) {
            let scaledFilteredImage = tempImage.colorInversion().toUIImage()!
            self.colorInversion.setImage(scaledFilteredImage, forState: UIControlState.Normal)
            self.colorInversion.backgroundColor = UIColor.clearColor()
        }
        dispatch_async(dispatch_get_main_queue()) {
            let scaledFilteredImage = tempImage.brightness(self.modifier).toUIImage()!
            self.brightness.setImage(scaledFilteredImage, forState: UIControlState.Normal)
            self.brightness.backgroundColor = UIColor.clearColor()
        }
        
    }
    
    func showSecondaryMeny(){
        view.addSubview(secondaryMenu)
        
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(100)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            self.secondaryMenu.alpha = 1.0
        })
        view.layoutIfNeeded()
        
    }
    
    func hideSecondaryMenu(){
        UIView.animateWithDuration(0.3, animations: ({self.secondaryMenu.alpha = 0}),
                                   completion: {completed in
                                    if completed {
                                        self.secondaryMenu.removeFromSuperview()}})
    }
    
    func showFilteredImageView(){
        
        self.filteredImageview.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            self.filteredImageview.alpha = 1.0
        })
        
        
        view.layoutIfNeeded()
        
    }
    
    func hideFilteredImageView(){
        UIView.animateWithDuration(0.3, animations: {
            self.filteredImageview.alpha = 0
        })
    }
    
    func showOriginalImageLabel() {
        self.originalImageLabel.alpha = 0
        UIView.animateWithDuration(0.5, animations: {
            self.originalImageLabel.alpha = 1.0
        })
    }
    
    func hideOriginalImageLabel(){
        UIView.animateWithDuration(0.5, animations: {
            self.originalImageLabel.alpha = 0
        })

    }
    
    
    func showSliderView(){
        view.addSubview(sliderView)
        
        
        let bottomConstraint = sliderView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = sliderView.heightAnchor.constraintEqualToConstant(50)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        self.sliderView.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            self.sliderView.alpha = 1.0
        })
        
        
        view.layoutIfNeeded()
        
    }
    
    func hideSliderView(){
        UIView.animateWithDuration(0.3, animations: {
            self.sliderView.alpha = 0
        })
    }
    
}













