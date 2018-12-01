//
//  TinkoffSnowMaker.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 01/12/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

@objc
protocol SnowMakerProtocol {
	func configureView(view: UIView)
}

class TinkoffSnowMaker: SnowMakerProtocol {

	private let particleEmitter = CAEmitterLayer()
	private let imageSize = CGSize(width: 20, height: 20)

	private weak var view: UIView?

	lazy private var panGestureRecogniser: UIPanGestureRecognizer = {
		return UIPanGestureRecognizer(target: self, action: #selector(self.onPan(sender:)))
	}()

	deinit {
		view?.removeGestureRecognizer(panGestureRecogniser)
	}

	func configureView(view: UIView) {
		particleEmitter.emitterShape = .circle
		particleEmitter.emitterSize = imageSize
		particleEmitter.emitterPosition = view.center
		particleEmitter.isOpaque = false
		particleEmitter.opacity = 0
		particleEmitter.emitterCells = [makeEmitterCell()]

		view.addGestureRecognizer(panGestureRecogniser)
		view.layer.addSublayer(particleEmitter)
		self.view = view
	}

	@objc
	func onPan(sender: UIPanGestureRecognizer) {
		guard let view = view else { return }
		switch sender.state {
		case .began:
			beginEmitting(position: sender.location(ofTouch: 0, in: view))
		case .changed:
			changePosition(to: sender.location(ofTouch: 0, in: view))
		case .ended, .cancelled:
			stopEmitting()
		default:
			return
		}
	}

	private func beginEmitting(position: CGPoint) {
		changePosition(to: position)
		particleEmitter.opacity = 1
	}

	private func changePosition(to position: CGPoint) {
		particleEmitter.emitterPosition = position
	}

	private func stopEmitting() {
		particleEmitter.opacity = 0
	}

	private func makeEmitterCell() -> CAEmitterCell {
		let cell = CAEmitterCell()
		cell.birthRate = 10
		cell.lifetime = 7.0
		cell.lifetimeRange = 0
		cell.velocity = 200
		cell.velocityRange = 50
		cell.emissionLongitude = CGFloat.pi * 2
		cell.emissionRange = CGFloat.pi * 2
		cell.spin = 2
		cell.spinRange = 3
		cell.scaleRange = 0.5
		cell.scaleSpeed = -0.05

		guard let image = UIImage(named: "tinkoff-logo")?.scaleToSize(imageSize) else { return cell }
		cell.contents = image.cgImage
		return cell
	}
}
