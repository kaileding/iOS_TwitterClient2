//
//  WipeViewController.swift
//  TwitterClient2
//
//  Created by DINGKaile on 11/5/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit

class WipeViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.willMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            self.closeMenu()
        }
    }
    
    @IBOutlet weak var contentLeftContraint: NSLayoutConstraint!
    var contentOriginalLeftConstraint: CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Pan Gesture Recognizer
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        
        if sender.state == UIGestureRecognizerState.began {
            self.contentOriginalLeftConstraint = self.contentLeftContraint.constant
            
        } else if sender.state == UIGestureRecognizerState.changed {
            if velocity.x < 0 && self.contentOriginalLeftConstraint == 0.0 {
                // should not swipe left when content view occupies the window
            } else {
                self.contentLeftContraint.constant = self.contentOriginalLeftConstraint! + translation.x
            }
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                if velocity.x > 0 {
                    self.contentLeftContraint.constant = self.view.frame.size.width - 50.0
                } else {
                    self.contentLeftContraint.constant = 0.0
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    
    // MARK: - Helper functions
    func closeMenu() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.contentLeftContraint.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    
    
    
    

}
