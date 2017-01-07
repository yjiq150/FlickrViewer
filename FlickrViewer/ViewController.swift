//
//  ViewController.swift
//  FlickrViewer
//
//  Created by yjiq150 on 07/01/2017.
//  Copyright © 2017 yjiq150. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import AlamofireImage
import SnapKit

class ViewController: UIViewController {

    var timer: Timer?
    
    let feedManager = FeedManager()
    
    let startButton = UIButton(type: .system)
    let durationSlider = UISlider()
    let durationLabel = UILabel()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)

        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(imageView)
        
        durationSlider.value = 1
        durationSlider.minimumValue = 1
        durationSlider.maximumValue = 10
        durationSlider.addTarget(self, action: #selector(onSliderChange), for: .valueChanged)
        view.addSubview(durationSlider)
        
        durationLabel.text = String(durationSlider.value)
        view.addSubview(durationLabel)
        

        startButton.setTitle("Start", for: .normal)
        startButton.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        view.addSubview(startButton)
        
        startButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.bottom.equalToSuperview().offset(-20)
            ConstraintMaker.centerX.equalToSuperview()
        }
        
        durationLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.bottom.equalTo(startButton.snp.top).offset(-20)
            ConstraintMaker.centerX.equalToSuperview()
        }
        
        durationSlider.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.bottom.equalTo(durationLabel.snp.top).offset(-5)
            ConstraintMaker.left.equalToSuperview().offset(20)
            ConstraintMaker.right.equalToSuperview().offset(-20)
        }
        
        updateImageViewContraint()
        
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate;
        hud.label.text = "Loading";
        
        feedManager.fetchFeedsIfNeeded(success: { 
            hud.hide(animated: true)
            
            if let mediaURL = self.feedManager.currentItem()?.mediaURL {
                if let url = URL(string: mediaURL) {
                    self.loadImage(url: url)
                }
            }
            
        }) { 
            hud.hide(animated: true)
            debugPrint("error occured")
        }
        
    }
    
    func updateImageViewContraint() {
        let size = self.view.frame.size
        
        let controllerHeight: CGFloat = 136
        var imageWidth: CGFloat
        if size.width > size.height {
            imageWidth = min(size.width, size.height - controllerHeight)
        } else {
            imageWidth = min(size.width, size.height)
        }
        
        imageView.snp.remakeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalToSuperview()
            ConstraintMaker.centerX.equalToSuperview()
            ConstraintMaker.height.equalTo(imageWidth)
            ConstraintMaker.width.equalTo(imageWidth)
        }
    }
    
    func orientationChanged() {
        updateImageViewContraint()
    }
    
    func onSliderChange() {
        durationLabel.text = String(durationSlider.value)
        resetTimer(interval: Double(durationSlider.value))
    }
    
    func startAction() {
        resetTimer(interval: Double(durationSlider.value))
    }
    
    func resetTimer(interval: Double) {
        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(onTimerFired), userInfo: nil, repeats: true);
    }
    
    func onTimerFired() {
        if let mediaURL = feedManager.nextItem()?.mediaURL {
            if let url = URL(string: mediaURL) {
                loadImage(url: url)
            }
        }
    }
    
    func loadImage(url: URL) {
        imageView.af_setImage(withURL: url,
                              placeholderImage: nil,
                              filter: nil,
                              progress: nil,
                              progressQueue: DispatchQueue.main,
                              imageTransition: .noTransition,
                              runImageTransitionIfCached: false,
                              completion: { (response: DataResponse<UIImage>) in
                                if response.result.isSuccess {
                                    UIView.transition(with: self.imageView,
                                                      duration: 0.3,
                                                      options: .transitionCrossDissolve,
                                                      animations: {
                                                        self.imageView.image = response.result.value
                                    },
                                                      completion: nil)
                                    
                                }
        })
    }

    deinit {
        if (timer != nil) {
            timer!.invalidate()
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        feedManager.clearFeeds();
    }


}

