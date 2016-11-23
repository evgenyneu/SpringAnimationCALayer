import UIKit

// Display the graph showing the motion of animated views
class GraphView: UIView {
  var graphData = [GraphPoint]()
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    // Draw UIView box Graph
    // ------------
    
    context?.beginPath()
    context?.setStrokeColor(UIColor.red.cgColor);
    var firstPoint = true
    
    for graphPoint in graphData {
      if firstPoint {
        context?.move(to: CGPoint(x: (CGFloat)(graphPoint.x), y: (CGFloat)(graphPoint.uiViewY)))
      } else {
        context?.addLine(to: CGPoint(x: (CGFloat)(graphPoint.x), y: (CGFloat)(graphPoint.uiViewY)))
      }
      
      firstPoint = false;
    }
    
    context?.strokePath()

    
    // Draw CALayer box Graph
    // ------------
    
    context?.beginPath()
    context?.setStrokeColor(UIColor.blue.cgColor);
    firstPoint = true
    
    for graphPoint in graphData {
      if firstPoint {
        context?.move(to: CGPoint(x: (CGFloat)(graphPoint.x), y: (CGFloat)(graphPoint.caLayerY)))
      } else {
        context?.addLine(to: CGPoint(x: (CGFloat)(graphPoint.x), y: (CGFloat)(graphPoint.caLayerY)))
      }
      
      firstPoint = false;
    }
    
    context?.strokePath()
  }
  
  func drawMotionGraphs(_ pointsToDraw: [GraphPoint]) {
    if pointsToDraw.isEmpty { return }
    graphData = shiftXZero(pointsToDraw)
    graphData = scaleXToFillWidth(graphData)
    graphData = scaleYToFillHeight(graphData)

    setNeedsDisplay()
  }
  
  // Make the X coordinates start from zero
  func shiftXZero(_ dataPoints: [GraphPoint]) -> [GraphPoint] {
    var firstTimestamp: CFTimeInterval = 0
    
    if dataPoints.count > 0 {
      firstTimestamp = dataPoints[0].x
    }
    
    var normalized = [GraphPoint]()
    
    for point in dataPoints {
      let normalizedPoint = GraphPoint(
        x :Double(point.x - firstTimestamp),
        uiViewY: Double(point.uiViewY),
        caLayerY: Double(point.caLayerY)
      );
      
      normalized.append(normalizedPoint)
    }

    return normalized
  }
  
  // Scale the X coordinates to fill the width of the view
  func scaleXToFillWidth(_ dataPoints: [GraphPoint]) -> [GraphPoint] {
    guard let lastPoint = dataPoints.last else { return [] }
    
    var lastPointX = lastPoint.x
    if (lastPointX == 0) { lastPointX = 1 }
  
    let scale: Double = Double(bounds.size.width) / lastPointX
    
    var normalized = [GraphPoint]()
    
    for point in dataPoints {
      let normalizedPoint = GraphPoint(
        x: point.x * scale,
        uiViewY: Double(point.uiViewY),
        caLayerY: Double(point.caLayerY));
      
      normalized.append(normalizedPoint)
    }
    
    return normalized
  }
  
  // Scale the Y coordinates to fill the heit of the view
  func scaleYToFillHeight(_ dataPoints: [GraphPoint]) -> [GraphPoint] {
    // Find minimum and maximum Y values
    
    var minY: Double = 100_000_000
    var maxY: Double = -100_000_000
    
    for point in dataPoints {
      if point.uiViewY > maxY { maxY = point.uiViewY }
      if point.uiViewY < minY { minY = point.uiViewY }
      
      if point.caLayerY > maxY { maxY = point.caLayerY }
      if point.caLayerY < minY { minY = point.caLayerY }
    }
    
    var heightSpan = maxY - minY;
    if heightSpan == 0 { heightSpan = 1 }
    
    let scaleY: Double = Double(bounds.size.height) / heightSpan

    // Scale the data points
    
    var normalized = [GraphPoint]()
    
    for point in dataPoints {
      let normalizedPoint = GraphPoint(
        x: point.x,
        uiViewY: point.uiViewY * scaleY - minY,
        caLayerY: point.caLayerY * scaleY - minY
      );
      
      normalized.append(normalizedPoint)
    }
    
    return normalized
  }
}
