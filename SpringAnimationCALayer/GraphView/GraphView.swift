import UIKit

// Display the graph showing the motion of animated views
class GraphView: UIView {
  var graphData = [GraphPoint]()
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    CGContextBeginPath(context)
    
    var firstPoint = true
    
    for graphPoint in graphData {
      if firstPoint {
        CGContextMoveToPoint(context, (CGFloat)(graphPoint.x), (CGFloat)(graphPoint.y))
      } else {
        CGContextAddLineToPoint(context, (CGFloat)(graphPoint.x), (CGFloat)(graphPoint.y))
      }
      
      firstPoint = false;
    }
    
    CGContextStrokePath(context)
  }
  
  func drawMotionGraphs(pointsToDraw: [GraphPoint]) {
    graphData = shiftXZero(pointsToDraw)
    graphData = scaleXToFillWidth(graphData)
    graphData = scaleYToFillHeight(graphData)

    setNeedsDisplay()
  }
  
  // Make the X coordinates start from zero
  func shiftXZero(dataPoints: [GraphPoint]) -> [GraphPoint] {
    var firstTimestamp: CFTimeInterval = 0
    
    if dataPoints.count > 0 {
      firstTimestamp = dataPoints[0].x
    }
    
    var normalized = [GraphPoint]()
    
    for point in dataPoints {
      let normalizedPoint = GraphPoint(x:Double(point.x - firstTimestamp), y:Double(point.y));
      normalized.append(normalizedPoint)
    }

    return normalized
  }
  
  // Scale the X coordinates to fill the width of the view
  func scaleXToFillWidth(dataPoints: [GraphPoint]) -> [GraphPoint] {
    guard let lastPoint = dataPoints.last else { return [] }
    
    var lastPointX = lastPoint.x
    if (lastPointX == 0) { lastPointX = 1 }
  
    let scale: Double = Double(bounds.size.width) / lastPointX
    
    var normalized = [GraphPoint]()
    
    for point in dataPoints {
      let normalizedPoint = GraphPoint(x: point.x * scale, y: point.y);
      normalized.append(normalizedPoint)
    }
    
    return normalized
  }
  
  // Scale the Y coordinates to fill the heit of the view
  func scaleYToFillHeight(dataPoints: [GraphPoint]) -> [GraphPoint] {
    // Find minimum and maximum Y values
    
    var minY: Double = 100_000_000
    var maxY: Double = -100_000_000
    
    for point in dataPoints {
      if point.y > maxY { maxY = point.y }
      if point.y < minY { minY = point.y }
    }
    
    var heightSpan = maxY - minY;
    if heightSpan == 0 { heightSpan = 1 }
    
    let scaleY: Double = Double(bounds.size.height) / heightSpan

    // Scale the data points
    
    var normalized = [GraphPoint]()
    
    for point in dataPoints {
      let normalizedPoint = GraphPoint(x: point.x, y: point.y * scaleY - minY);
      normalized.append(normalizedPoint)
    }
    
    return normalized
  }
}