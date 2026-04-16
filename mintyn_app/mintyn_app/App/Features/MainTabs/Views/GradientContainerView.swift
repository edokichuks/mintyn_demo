import UIKit

final class GradientContainerView: UIView {
    var colors: [UIColor] = [] {
        didSet {
            updateGradient()
        }
    }
    
    var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            gradientLayer.startPoint = startPoint
        }
    }
    
    var endPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
        didSet {
            gradientLayer.endPoint = endPoint
        }
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateGradient()
    }

    private func updateGradient() {
        // Resolve dynamic colors correctly when traits change
        let resolvedColors = colors.map { $0.resolvedColor(with: traitCollection).cgColor }
        gradientLayer.colors = resolvedColors
    }
}
