//
//  SKZoomingScrollView.swift
//  SKViewExample
//
//  Created by suzuki_keihsi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit

open class SKZoomingScrollView: UIScrollView, UIScrollViewDelegate, SKDetectingViewDelegate, SKDetectingImageViewDelegate {
    
    var captionView: SKCaptionView!
    var photo: SKPhotoProtocol! {
        didSet {
            photoImageView.image = nil
            if photo != nil {
                displayImage()
            }
        }
    }
    
    fileprivate(set) var photoImageView: SKDetectingImageView!
    fileprivate weak var photoBrowser: SKPhotoBrowser?
    fileprivate var tapView: SKDetectingView!
    fileprivate var indicatorView: SKIndicatorView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(frame: CGRect, browser: SKPhotoBrowser) {
        self.init(frame: frame)
        photoBrowser = browser
        setup()
    }
    
    deinit {
        photoBrowser = nil
    }
    
    func setup() {
        // tap
        tapView = SKDetectingView(frame: bounds)
        tapView.delegate = self
        tapView.backgroundColor = UIColor.clear
        tapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(tapView)
        
        // image
        photoImageView = SKDetectingImageView(frame: frame)
        photoImageView.delegate = self
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.backgroundColor = .clear()
        addSubview(photoImageView)
        
        // indicator
        indicatorView = SKIndicatorView(frame: frame)
        addSubview(indicatorView)
        
        // self
        backgroundColor = .clear()
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        decelerationRate = UIScrollViewDecelerationRateFast
        autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin]
    }
    
    // MARK: - override
    open override func layoutSubviews() {
        tapView.frame = bounds
        
        super.layoutSubviews()
        
        let boundsSize = bounds.size
        var frameToCenter = photoImageView.frame
        
        // horizon
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2)
        } else {
            frameToCenter.origin.x = 0
        }
        // vertical
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2)
        } else {
            frameToCenter.origin.y = 0
        }
        
        // Center
        if !photoImageView.frame.equalTo(frameToCenter) {
            photoImageView.frame = frameToCenter
        }
    }
    
    open func setMaxMinZoomScalesForCurrentBounds() {
        
        maximumZoomScale = 1
        minimumZoomScale = 1
        zoomScale = 1
        
        guard let photoImageView = photoImageView else {
            return
        }
        
        let boundsSize = bounds.size
        let imageSize = photoImageView.frame.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale: CGFloat = min(xScale, yScale)
        var maxScale: CGFloat!
        
        let deviceScreenWidth = UIScreen.main.bounds.width
        
        if photoImageView.frame.width < deviceScreenWidth {
            if deviceScreenWidth / 2 > photoImageView.frame.width {
                maxScale = 3.0
            } else {
                maxScale = 2.0
            }
        } else {
            maxScale = 1.0
        }
        
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale
        zoomScale = minScale
        
        // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
        // maximum zoom scale to 0.5
        maxScale = maxScale / UIScreen.main.scale
        if maxScale < minScale {
            maxScale = minScale * 2
        }
        
        // reset position
        photoImageView.frame = CGRect(x: 0, y: 0, width: photoImageView.frame.size.width, height: photoImageView.frame.size.height)
        setNeedsLayout()
    }
    
    open func prepareForReuse() {
        photo = nil
        if captionView != nil {
            captionView.removeFromSuperview()
            captionView = nil 
        }
    }
    
    // MARK: - image
    open func displayImage() {
        // reset scale
        maximumZoomScale = 1
        minimumZoomScale = 1
        zoomScale = 1
        contentSize = CGSize.zero
        
        if let image = photoBrowser?.imageForPhoto(photo) {
            // indicator
            indicatorView.stopAnimating()
            
            // image
            photoImageView.image = image
            
            var photoImageViewFrame = CGRect.zero
            photoImageViewFrame.origin = CGPoint.zero
            photoImageViewFrame.size = image.size
            
            photoImageView.frame = photoImageViewFrame
            
            contentSize = photoImageViewFrame.size
            
            setMaxMinZoomScalesForCurrentBounds()
        } else {
            // indicator
            indicatorView.startAnimating()
        }
        
        setNeedsLayout()
    }
    
    open func displayImageFailure() {
        indicatorView.stopAnimating()
    }
    
    
    // MARK: - handle tap
    open func handleDoubleTap(_ touchPoint: CGPoint) {
        if let photoBrowser = photoBrowser {
            NSObject.cancelPreviousPerformRequests(withTarget: photoBrowser)
        }
        
        if zoomScale > minimumZoomScale {
            // zoom out
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            // zoom in
            var newZoom: CGFloat = zoomScale * 3.13
            if newZoom >= maximumZoomScale {
                newZoom = maximumZoomScale
            }
            
            zoom(to: zoomRectForScrollViewWith(newZoom, touchPoint:touchPoint), animated:true)
        }
        
        // delay control
        photoBrowser?.hideControlsAfterDelay()
    }
    
    open func zoomRectForScrollViewWith(_ scale: CGFloat, touchPoint: CGPoint) -> CGRect {
        let w = frame.size.width / scale
        let h = frame.size.height / scale
        let x = touchPoint.x - (w / 2.0)
        let y = touchPoint.y - (h / 2.0)
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    // MARK: - UIScrollViewDelegate
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        photoBrowser?.cancelControlHiding()
    }
    
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    
    // MARK: - SKDetectingViewDelegate
    func handleSingleTap(_ view: UIView, touch: UITouch) {
        if photoBrowser?.enableZoomBlackArea == true {
            photoBrowser?.toggleControls()
        }
    }
    
    func handleDoubleTap(_ view: UIView, touch: UITouch) {
        if photoBrowser?.enableZoomBlackArea == true {
            let needPoint = getViewFramePercent(view, touch: touch)
            handleDoubleTap(needPoint)
        }
    }
    
    fileprivate func getViewFramePercent(_ view: UIView, touch: UITouch) -> CGPoint {
        let oneWidthViewPercent = view.bounds.width / 100
        let viewTouchPoint = touch.location(in: view)
        let viewWidthTouch = viewTouchPoint.x
        let viewPercentTouch = viewWidthTouch / oneWidthViewPercent
        
        let photoWidth = photoImageView.bounds.width
        let onePhotoPercent = photoWidth / 100
        let needPoint = viewPercentTouch * onePhotoPercent
        
        var Y: CGFloat!
        
        if viewTouchPoint.y < view.bounds.height / 2 {
            Y = 0
        } else {
            Y = photoImageView.bounds.height
        }
        let allPoint = CGPoint(x: needPoint, y: Y)
        return allPoint
    }
    
    // MARK: - SKDetectingImageViewDelegate
    func handleImageViewSingleTap(_ view: UIImageView, touch: UITouch) {
        photoBrowser?.toggleControls()
    }
    
    func handleImageViewDoubleTap(_ view: UIImageView, touch: UITouch) {
        handleDoubleTap(touch.location(in: view))
    }
}
