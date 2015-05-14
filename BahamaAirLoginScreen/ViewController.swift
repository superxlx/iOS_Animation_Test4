/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

// A delay function
func delay(#seconds: Double, completion:()->()) {
  let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
  
  dispatch_after(popTime, dispatch_get_main_queue()) {
    completion()
  }
}

func tintBackgroundColor(#layer: CALayer, #toColor: UIColor) {
  
  let tint = CABasicAnimation(keyPath: "backgroundColor")
  tint.fromValue = layer.backgroundColor
  tint.toValue = toColor.CGColor
  tint.duration = 1.0
  layer.addAnimation(tint, forKey: nil)
  layer.backgroundColor = toColor.CGColor
}

func roundCorners(#layer: CALayer, #toRadius: CGFloat) {
  
  let round = CABasicAnimation(keyPath: "cornerRadius")
  round.fromValue = layer.cornerRadius
  round.toValue = toRadius
  round.duration = 0.33
  layer.addAnimation(round, forKey: nil)
  layer.cornerRadius = toRadius
}

class ViewController: UIViewController {
  
  // MARK: IB outlets
  
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!
  
  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!
  
  // MARK: further UI
  
  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
  let status = UIImageView(image: UIImage(named: "banner"))
  let label = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
  
  var statusPosition = CGPoint.zeroPoint
  let info = UILabel()
  
  // MARK: view controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true
    
    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)
    
    status.hidden = true
    status.center = loginButton.center
    view.addSubview(status)
    
    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .Center
    status.addSubview(label)
    
    statusPosition = status.center
    
    info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0,
      width: view.frame.size.width, height: 30)
    info.backgroundColor = UIColor.clearColor()
    info.font = UIFont(name: "HelveticaNeue", size: 12.0)
    info.textAlignment = .Center
    info.textColor = UIColor.whiteColor()
    info.text = "Tap on a field and enter username and password"
    view.insertSubview(info, belowSubview: loginButton)

  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    delay(seconds: 5.0, {
      println("where are the fields?")
    })
    
    let fadeIn = CABasicAnimation(keyPath: "opacity")
    fadeIn.fromValue = 0.0
    fadeIn.toValue = 1.0
    fadeIn.duration = 0.5
    fadeIn.fillMode = kCAFillModeBackwards
    fadeIn.beginTime = CACurrentMediaTime() + 0.5
    cloud1.layer.addAnimation(fadeIn, forKey: nil)
    
    fadeIn.beginTime = CACurrentMediaTime() + 0.7
    cloud2.layer.addAnimation(fadeIn, forKey: nil)
    
    fadeIn.beginTime = CACurrentMediaTime() + 0.9
    cloud3.layer.addAnimation(fadeIn, forKey: nil)
    
    fadeIn.beginTime = CACurrentMediaTime() + 1.1
    cloud4.layer.addAnimation(fadeIn, forKey: nil)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    let formGroup = CAAnimationGroup()
    formGroup.duration = 0.5
    formGroup.fillMode = kCAFillModeBackwards

    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width/2
    flyRight.toValue = view.bounds.size.width/2

    let fadeFieldIn = CABasicAnimation(keyPath: "opacity")
    fadeFieldIn.fromValue = 0.25
    fadeFieldIn.toValue = 1.0

    formGroup.animations = [flyRight, fadeFieldIn]
    heading.layer.addAnimation(formGroup, forKey: nil)
    
    formGroup.delegate = self
    formGroup.setValue("form", forKey: "name")
    formGroup.setValue(username.layer, forKey: "layer")

    formGroup.beginTime = CACurrentMediaTime() + 0.3
    username.layer.addAnimation(formGroup, forKey: nil)
    
    formGroup.setValue(password.layer, forKey: "layer")
    formGroup.beginTime = CACurrentMediaTime() + 0.4
    password.layer.addAnimation(formGroup, forKey: nil)

    let groupAnimation = CAAnimationGroup()
    groupAnimation.beginTime = CACurrentMediaTime() + 0.5
    groupAnimation.duration = 0.5
    groupAnimation.fillMode = kCAFillModeBackwards
    groupAnimation.timingFunction = CAMediaTimingFunction(
      name: kCAMediaTimingFunctionEaseIn)

    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
    scaleDown.fromValue = 3.5
    scaleDown.toValue = 1.0

    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = CGFloat(M_PI_4)
    rotate.toValue = 0.0

    let fade = CABasicAnimation(keyPath: "opacity")
    fade.fromValue = 0.0
    fade.toValue = 1.0

    groupAnimation.animations = [scaleDown, rotate, fade]
    loginButton.layer.addAnimation(groupAnimation, forKey: nil)
    
    animateCloud(cloud1.layer)
    animateCloud(cloud2.layer)
    animateCloud(cloud3.layer)
    animateCloud(cloud4.layer)
    
    let flyLeft = CABasicAnimation(keyPath: "position.x")
    flyLeft.fromValue = info.layer.position.x +
      view.frame.size.width
    flyLeft.toValue = info.layer.position.x
    flyLeft.duration = 5.0
    info.layer.addAnimation(flyLeft, forKey: "infoappear")
    
    let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
    fadeLabelIn.fromValue = 0.2
    fadeLabelIn.toValue = 1.0
    fadeLabelIn.duration = 4.5
    info.layer.addAnimation(fadeLabelIn, forKey: "fadein")
    
    username.delegate = self
    password.delegate = self
  }
  
  // MARK: further methods
  
  @IBAction func login() {

    UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: nil, animations: {
      self.loginButton.bounds.size.width += 80.0
    }, completion: nil)

    UIView.animateWithDuration(0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: nil, animations: {
      self.loginButton.center.y += 60.0
      
      self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
      self.spinner.alpha = 1.0

    }, completion: {_ in
      self.showMessage(index: 0)
    })
    
    let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
    tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
    
    roundCorners(layer: loginButton.layer, toRadius: 25.0)
    
    let balloon = CALayer()
    balloon.contents = UIImage(named: "balloon")!.CGImage
    balloon.frame = CGRect(x: -50.0, y: 0.0,
      width: 50.0, height: 65.0)
    view.layer.insertSublayer(balloon, below: username.layer)

    let flight = CAKeyframeAnimation(keyPath: "position")
    flight.duration = 12.0

    flight.values = [
      CGPoint(x: -50.0, y: 0.0),
      CGPoint(x: view.frame.width + 50.0, y: 160.0),
      CGPoint(x: -50.0, y: loginButton.center.y)
      ].map { NSValue(CGPoint: $0) }
    flight.keyTimes = [0.0, 0.5, 1.0]

    balloon.addAnimation(flight, forKey: nil)
    balloon.position = CGPoint(x: -50.0, y: loginButton.center.y)

  }

  func showMessage(#index: Int) {
    label.text = messages[index]
    
    UIView.transitionWithView(status, duration: 0.33, options:
      .CurveEaseOut | .TransitionFlipFromBottom, animations: {
        self.status.hidden = false
      }, completion: {_ in
        //transition completion
        delay(seconds: 2.0) {
          if index < self.messages.count-1 {
            self.removeMessage(index: index)
          } else {
            //reset form
            self.resetForm()
          }
        }
    })
  }

  func removeMessage(#index: Int) {
    UIView.animateWithDuration(0.33, delay: 0.0, options: nil, animations: {
      self.status.center.x += self.view.frame.size.width
    }, completion: {_ in
      self.status.hidden = true
      self.status.center = self.statusPosition
      self.showMessage(index: index+1)
    })
  }

  func resetForm() {
    let wobble = CAKeyframeAnimation(keyPath: "transform.rotation")
    wobble.duration = 0.25
    wobble.repeatCount = 4
    wobble.values = [0.0, -M_PI_4/4, 0.0, M_PI_4/4, 0.0]
    wobble.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
    heading.layer.addAnimation(wobble, forKey: nil)

    
    UIView.transitionWithView(status, duration: 0.2, options: .TransitionFlipFromTop, animations: {
      self.status.hidden = true
      self.status.center = self.statusPosition
    }, completion: nil)
    
    UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
      self.spinner.center = CGPoint(x: -20.0, y: 16.0)
      self.spinner.alpha = 0.0
      self.loginButton.bounds.size.width -= 80.0
      self.loginButton.center.y -= 60.0
    }, completion: {_ in
      let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
      tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
      roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
    })
  }

  func animateCloud(layer: CALayer) {
    //1
    let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
    let duration: NSTimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
    
    //2
    let cloudMove = CABasicAnimation(keyPath: "position.x")
    cloudMove.duration = duration
    cloudMove.toValue = self.view.bounds.size.width + layer.bounds.width/2
    cloudMove.delegate = self
    cloudMove.setValue("cloud", forKey: "name")
    cloudMove.setValue(layer, forKey: "layer")
    
    layer.addAnimation(cloudMove, forKey: nil)
  }
  override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
    println("animation did finish")
    
    if let name = anim.valueForKey("name") as? String {
      if name == "form" {
        //form field found
        let layer = anim.valueForKey("layer") as? CALayer
        anim.setValue(nil, forKey: "layer")
        
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.25
        pulse.toValue = 1.0
        pulse.duration = 0.25
        layer?.addAnimation(pulse, forKey: nil)

      }
      if name == "cloud" {
        if let layer = anim.valueForKey("layer") as? CALayer {
          anim.setValue(nil, forKey: "layer")
          
          layer.position.x = -layer.bounds.width/2
          delay(seconds: 0.5, {
            self.animateCloud(layer)
          })
        }
      }
    }

  }

}

extension ViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(textField: UITextField) {
    println(info.layer.animationKeys())
    info.layer.removeAnimationForKey("infoappear")
  }
}

