import UIKit

// Display the graph showing the motion of animated views
class GraphView: UIView {
  var graphData = [GraphPoint]()
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    // Draw UIView box Graph
    // ------------
    
    CGContextBeginPath(context)
    CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor);
    var firstPoint = true
    
    for graphPoint in graphData {
      if firstPoint {
        CGContextMoveToPoint(context, (CGFloat)(graphPoint.x), (CGFloat)(graphPoint.uiViewY))
      } else {
        CGContextAddLineToPoint(context, (CGFloat)(graphPoint.x), (CGFloat)(graphPoint.uiViewY))
      }
      
      firstPoint = false;
    }
    
    CGContextStrokePath(context)

    
    // Draw CALayer box Graph
    // ------------
    
    CGContextBeginPath(context)
    CGContextSetStrokeColorWithColor(context, UIColor.greenColor().CGColor);
    firstPoint = true
    
    for graphPoint in graphData {
      if firstPoint {
        CGContextMoveToPoint(context, (CGFloat)(graphPoint.x), (CGFloat)(graphPoint.caLayerY))
      } else {
        CGContextAddLineToPoint(context, (CGFloat)(graphPoint.x), (CGFloat)(graphPoint.caLayerY))
      }
      
      firstPoint = false;
    }
    
    CGContextStrokePath(context)
  }
  
  func drawMotionGraphs(pointsToDraw: [GraphPoint]) {
    if pointsToDraw.isEmpty { return }
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
  func scaleXToFillWidth(dataPoints: [GraphPoint]) -> [GraphPoint] {
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
  func scaleYToFillHeight(dataPoints: [GraphPoint]) -> [GraphPoint] {
    // Find minimum and maximum Y values
    
    var minY: Double = 100_000_000
    var maxY: Double = -100_000_000
    
    for point in dataPoints {
      if point.uiViewY > maxY { maxY = point.uiViewY }
      if point.uiViewY < minY { minY = point.uiViewY }
      
//      if point.caLayerY > maxY { maxY = point.caLayerY }
//      if point.caLayerY < minY { minY = point.caLayerY }
    }
    
    var heightSpan = maxY - minY;
    if heightSpan == 0 { heightSpan = 1 }
    
    let scaleY: Double = Double(bounds.size.height) / heightSpan

    // Scale the data points
    
    var normalized = [GraphPoint]()
    
    for point in dataPoints {
      let normalizedPoint = GraphPoint(
        x: point.x,
        uiViewY: (point.uiViewY - minY) * scaleY,
        caLayerY: (point.caLayerY - minY) * scaleY
      );
      
      normalized.append(normalizedPoint)
    }
    
    return normalized
  }
}