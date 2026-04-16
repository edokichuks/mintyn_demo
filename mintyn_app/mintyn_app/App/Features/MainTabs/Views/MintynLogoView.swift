import UIKit

final class MintynLogoView: UIView {
    var iconTintColor: UIColor = .white {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        
        iconTintColor.setFill()
        
        let spacing: CGFloat = rect.width * 0.15
        let itemSize = (rect.width - spacing) / 2
        
        let tlRect = CGRect(x: 0, y: 0, width: itemSize, height: itemSize)
        UIBezierPath(ovalIn: tlRect).fill()
        
        let trRect = CGRect(x: itemSize + spacing, y: 0, width: itemSize, height: itemSize)
        UIBezierPath(ovalIn: trRect).fill()
        
        let blRect = CGRect(x: 0, y: itemSize + spacing, width: itemSize, height: itemSize)
        UIBezierPath(ovalIn: blRect).fill()
        
        let brRect = CGRect(x: itemSize + spacing, y: itemSize + spacing, width: itemSize, height: itemSize)
        let teardrop = UIBezierPath(
            roundedRect: brRect,
            byRoundingCorners: [.topLeft, .topRight, .bottomLeft],
            cornerRadii: CGSize(width: itemSize / 2, height: itemSize / 2)
        )
        teardrop.fill()
    }
}
