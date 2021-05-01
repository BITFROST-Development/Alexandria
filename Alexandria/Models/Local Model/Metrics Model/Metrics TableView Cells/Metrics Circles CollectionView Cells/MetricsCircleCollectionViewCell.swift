//
//  MetricsCircleCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/21/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class MetricsCircleCollectionViewCell: UICollectionViewCell {

    static var identifier = "MetricsCircleCollectionViewCell"
    
    var controller: GoalDisplayableDelegate!
    var currentGoal: Goal!
    
    @IBOutlet weak var goalProgressBar: RingProgressBar!
    @IBOutlet weak var percentageCompleted: UILabel!
    @IBOutlet weak var tasksRemaining: UILabel!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var preferencesChevron: UIImageView!
    @IBOutlet weak var sizeOfRing: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func toEditingGoal(_ sender: Any) {
        
    }
}

@IBDesignable
class RingProgressBar: UIView {
    
    @IBInspectable var color: UIColor? = .gray {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var ringWidth: CGFloat = 0.0
    private let progressLayer = CAShapeLayer()
    private let backgroundMask = CAShapeLayer()
    var progress: CGFloat = 0.5 {
        didSet { setNeedsDisplay() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers(){
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask
        
        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }
    
    override func draw(_ rect: CGRect) {
        
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask
        
        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil

        
        progressLayer.path = circlePath.cgPath
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = color?.cgColor
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }
}
