//
//  AvatarView.swift
//  AvatarView
//
//  Created by ChristianEnevoldsen on 08/06/15.
//  Copyright (c) 2015 che. All rights reserved.
//

import UIKit

open class AvatarView: UIView {

  // The UIImageView that displays the avatar
    public let imageView = UIImageView()

  // Responsible for drawing the border
  // Do not set the strokeColor or lineWidth on this. Instead use the API
  // see borderColor, borderWidth
    public let borderLayer = CAShapeLayer()

  // The images mask
  fileprivate let imageMask = CAShapeLayer()

  // The image / avatar
  open var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }

  // The border color for the avatar
  // Setting the borderColor updates the borderLayers strokeColor
  open var borderColor: UIColor? {
    didSet {
      borderLayer.strokeColor = borderColor?.cgColor
    }
  }

  // The border width for the avatar
  // Setting the borderWidth updates the borderLayers lineWidth
  open var borderWidth: CGFloat = 0 {
    didSet {
      borderLayer.lineWidth = borderWidth * 2
    }
  }

  public init(image: UIImage) {
    self.image = image

    let imageSize = max(image.size.width, image.size.height)
    super.init(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))

    setup()
    setupDefaults()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
    setupDefaults()
  }

  // Sets up the view after it's initialized
  fileprivate func setup() {
    layer.addSublayer(borderLayer)
    addSubview(imageView)

    // Smoothens the border
    borderLayer.contentsScale = 2.0 * UIScreen.main.scale

    // Explicitly set the image
    imageView.image = image

    // Mask the image
    imageView.layer.mask = imageMask
  }

  // Sets up the default colors etc.
  func setupDefaults() {
    // Keep the images dimensions
    imageView.contentMode = .scaleAspectFill

    // Set default border widths
    borderWidth = 1.0
    borderColor = UIColor.white
  }

  // Layouts the subview
  open override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = bounds
  }

  // Layouts the layers

  open override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)

    // Makes room for the the border
    let insetsSize = borderWidth
    let rectInsets = bounds.insetBy(dx: insetsSize, dy: insetsSize)

    // Update the path to fit the frame
    imageMask.path = UIBezierPath(ovalIn: rectInsets).cgPath
    borderLayer.path = imageMask.path
    borderLayer.frame = bounds
  }

}
