//
//  YPLibraryVC+PanGesture.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 26/01/2018.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import UIKit

enum DragDirection {
    case scroll
    case stop
    case up
    case down
}


public class PanGestureHelper: NSObject, UIGestureRecognizerDelegate {
    
    var v: GalleryView!
    private let assetViewContainerOriginalConstraintTop: CGFloat = 0
    private var dragDirection = DragDirection.up
    private var imaginaryCollectionViewOffsetStartPosY: CGFloat = 0.0
    private var cropBottomY: CGFloat  = 0.0
    private var dragStartPos: CGPoint = .zero
    private let dragDiff: CGFloat = 0
    private var _isImageShown = true
    
    // The height constraint of the view with main selected image
    var topHeight: CGFloat {
        get {
            return v.assetViewContainerConstraintTop?.constant ?? 0
        }
        set {
            if newValue >= v.assetZoomableViewMinimalVisibleHeight - v.bannerView.frame.height {
                v.assetViewContainerConstraintTop?.constant = newValue
            }
        }
    }
    
    // Is the main image shown
    var isImageShown: Bool {
        get { return self._isImageShown }
        set {
            if newValue != isImageShown {
                self._isImageShown = newValue
//                v.bannerView.isShown = newValue
                // Update imageCropContainer
//                v.bannerView.isScrollEnabled = isImageShown
            }
        }
    }
    
    func registerForPanGesture(on view: GalleryView) {
        v = view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        topHeight = 0
    }
    
    public func resetToOriginalState() {
        topHeight = assetViewContainerOriginalConstraintTop
        animateView()
        dragDirection = .up
    }
    
    fileprivate func animateView() {
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: [.curveEaseInOut, .beginFromCurrentState],
                       animations: {
//                        self.v.refreshImageCurtainAlpha()
                        self.v.layoutIfNeeded()
        }
            ,
                       completion: nil)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith
        otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let p = gestureRecognizer.location(ofTouch: 0, in: v)
        // Desactivate pan on image when it is shown.
        if isImageShown {
            if p.y < v.bannerView.frame.height {
                return false
            }
        }
        return true
    }
    
    @objc
    func panned(_ sender: UIPanGestureRecognizer) {
        
        let containerHeight = v.bannerView.frame.height
        let currentPos = sender.location(in: v)
        let overYLimitToStartMovingUp = currentPos.y * 1.4 < cropBottomY - dragDiff
        
        switch sender.state {
        case .began:
            let view    = sender.view
            let loc     = sender.location(in: view)
            let subview = view?.hitTest(loc, with: nil)
            
            if subview == v.bannerView
                && topHeight == assetViewContainerOriginalConstraintTop {
                return
            }
            
            dragStartPos = sender.location(in: v)
            cropBottomY = v.bannerView.frame.origin.y + containerHeight
            
            // Move
            if dragDirection == .stop {
                dragDirection = (topHeight == assetViewContainerOriginalConstraintTop)
                    ? .up
                    : .down
            }
            
            // Scroll event of CollectionView is preferred.
            if (dragDirection == .up && dragStartPos.y < cropBottomY + dragDiff) ||
                (dragDirection == .down && dragStartPos.y > cropBottomY) {
                dragDirection = .stop
            }
        case .changed:
            switch dragDirection {
            case .up:
                if currentPos.y < cropBottomY - dragDiff {
                    topHeight =
                        max(v.assetZoomableViewMinimalVisibleHeight - containerHeight,
                            currentPos.y + dragDiff - containerHeight)
                }
            case .down:
                if currentPos.y > cropBottomY {
                    topHeight =
                        min(assetViewContainerOriginalConstraintTop, currentPos.y - containerHeight)
                }
            case .scroll:
                topHeight =
                    v.assetZoomableViewMinimalVisibleHeight - containerHeight
                    + currentPos.y - imaginaryCollectionViewOffsetStartPosY
            case .stop:
                if v.collectionView.contentOffset.y < 0 {
                    dragDirection = .scroll
                    imaginaryCollectionViewOffsetStartPosY = currentPos.y
                }
            }
            
        default:
            imaginaryCollectionViewOffsetStartPosY = 0.0
            if sender.state == UIGestureRecognizer.State.ended && dragDirection == .stop {
                return
            }
            
            if overYLimitToStartMovingUp && isImageShown == false {
                // The largest movement
                topHeight =
                    v.assetZoomableViewMinimalVisibleHeight - containerHeight
                animateView()
                dragDirection = .down
            } else {
                // Get back to the original position
                resetToOriginalState()
            }
        }
        
        // Update isImageShown
        isImageShown = topHeight == assetViewContainerOriginalConstraintTop
    }
}
