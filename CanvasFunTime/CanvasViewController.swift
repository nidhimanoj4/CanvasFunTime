//
//  CanvasViewController.swift
//  CanvasFunTime
//
//  Created by Nidhi Manoj on 6/30/16.
//  Copyright © 2016 Nidhi Manoj. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var downArrow: UIImageView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 200
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)
    }
    
    @IBAction func didPanFace(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        if (sender.state == .Began) {
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            view.addSubview(newlyCreatedFace)
            
            //Create a Pan Gesture Recognizer that calls onCustomPan and allows you to continue to pan the face
            let gestureRecognizerForFace = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
            newlyCreatedFace.addGestureRecognizer(gestureRecognizerForFace)
    
            //Create a Pinch Gesture Recognizer that allows you to scale the size of the face
            let pinchgestureRecognizerForFace = UIPinchGestureRecognizer(target: self, action: "onCustomScale:")
            newlyCreatedFace.addGestureRecognizer(pinchgestureRecognizerForFace)
            pinchgestureRecognizerForFace.delegate = self
            
            //Create a Tap Gesture Recognizer that allows you to delete the face on 2 taps
            let tapgestureRecognizerForFace = UITapGestureRecognizer(target: self, action: "onCustomDelete:")
            tapgestureRecognizerForFace.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(tapgestureRecognizerForFace)
            
            newlyCreatedFace.userInteractionEnabled = true
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            UIView.animateWithDuration(0.3, animations: { 
                self.newlyCreatedFace.transform = CGAffineTransformScale(self.newlyCreatedFace.transform, 1.5,1.5)
            })
            
        } else if (sender.state == .Changed) {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if (sender.state == .Ended) {
            
            
            UIView.animateWithDuration(0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransformScale(self.newlyCreatedFace.transform, 2/3,2/3)
            })
        }
    }

    func onCustomPan(sender: UIPanGestureRecognizer){
        let translation = sender.translationInView(view)
        if (sender.state == .Began){
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            UIView.animateWithDuration(0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransformScale(self.newlyCreatedFace.transform, 1.5,1.5)
            })
        }else if (sender.state == .Changed){
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }else if (sender.state == .Ended){
            UIView.animateWithDuration(0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransformScale(self.newlyCreatedFace.transform, 2/3,2/3)
            })
        }
    }
    
    func onCustomScale(sender: UIPinchGestureRecognizer) {
        let scaleValue = sender.scale
        UIView.animateWithDuration(0.3) { 
            self.newlyCreatedFace.transform = CGAffineTransformScale(self.newlyCreatedFace.transform, scaleValue, scaleValue)
        }
    }
    
    func onCustomDelete(sender: UITapGestureRecognizer){
        let newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.removeFromSuperview()
    }
    
    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let doesArrowPointUp = false
        
        if (sender.state == .Began) {
            trayOriginalCenter = trayView.center
        } else if (sender.state == .Changed) {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
        } else if (sender.state == .Ended) {
            var velocity = sender.velocityInView(view)
            if velocity.y < 0{
                UIView.animateWithDuration(0.3, animations: {
                    self.trayView.center = self.trayUp
                })
            }else{
                UIView.animateWithDuration(0.3, animations: {
                    self.trayView.center = self.trayDown
                })
            }
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
