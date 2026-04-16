import UIKit

func createCurvePath(bounds: CGRect, cutoutWidth: CGFloat, cutoutDepth: CGFloat) -> UIBezierPath {
    let path = UIBezierPath()
    let width = bounds.width
    let height = bounds.height
    
    let center = width / 2
    let curveStartX = center - cutoutWidth / 2
    let curveEndX = center + cutoutWidth / 2
    
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: curveStartX, y: 0))
    
    // Cubic bezier curve for a smooth dip
    let cp1 = CGPoint(x: curveStartX + cutoutWidth * 0.25, y: 0)
    let cp2 = CGPoint(x: curveStartX + cutoutWidth * 0.25, y: cutoutDepth)
    let bottom = CGPoint(x: center, y: cutoutDepth)
    path.addCurve(to: bottom, controlPoint1: cp1, controlPoint2: cp2)
    
    let cp3 = CGPoint(x: curveEndX - cutoutWidth * 0.25, y: cutoutDepth)
    let cp4 = CGPoint(x: curveEndX - cutoutWidth * 0.25, y: 0)
    path.addCurve(to: CGPoint(x: curveEndX, y: 0), controlPoint1: cp3, controlPoint2: cp4)
    
    path.addLine(to: CGPoint(x: width, y: 0))
    path.addLine(to: CGPoint(x: width, y: height))
    path.addLine(to: CGPoint(x: 0, y: height))
    path.close()
    
    return path
}
