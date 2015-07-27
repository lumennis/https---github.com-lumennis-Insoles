//
//  GradientOverlayRenderer.m
//  Digitsole
//
//  Created by Evgeniy on 15/05/2015.
//  Copyright (c) 2015 Glaglashoes. All rights reserved.
//

#import "GradientOverlayPathRenderer.h"
#import "UtilitiesManager.h"

@interface GradientOverlayPathRenderer ()
{
    DatePolyline *theDatePolyline;
}

@end

@implementation GradientOverlayPathRenderer

- (instancetype)initWithOverlay:(id <MKOverlay>)overlay
{
    self = [super initWithOverlay:overlay];
    if (self)
    {
        theDatePolyline = (DatePolyline *)overlay;
    }
    return self;
}

- (void)createPath
{
    CGPoint theStartPoint = [self pointForMapPoint:((MKMapPoint)theDatePolyline.points[0])];
    CGPoint theFinishPoint = [self pointForMapPoint:((MKMapPoint)theDatePolyline.points[1])];
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, nil, theStartPoint.x, theStartPoint.y);
    CGPathAddLineToPoint(thePath, nil, theFinishPoint.x, theFinishPoint.y);
    self.path = thePath;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{
    MKMapPoint theCurrentCoordinate = theDatePolyline.points[1];
    MKMapPoint thePreviousCoordinate = theDatePolyline.points[0];
    CGPoint theCurrentpoint = [self pointForMapPoint:theCurrentCoordinate];
    CGPoint thePreviousPoint = [self pointForMapPoint:thePreviousCoordinate];
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, nil, thePreviousPoint.x, thePreviousPoint.y);
    CGPathAddLineToPoint(thePath, nil, theCurrentpoint.x, theCurrentpoint.y);
    
    CGFloat theStartRed, theStartGreen, theFinishRed, theFinishGreen;
    [theDatePolyline.theStartColor getRed:&theStartRed green:&theStartGreen blue:nil alpha:nil];
    [theDatePolyline.theFinishColor getRed:&theFinishRed green:&theFinishGreen blue:nil alpha:nil];
    CGFloat gradientColors[8] = {theStartRed, theStartGreen, 0, 1, theFinishRed, theFinishGreen, 0, 1};
    
    CGFloat gradientLocation[2] = {0, 1};
    
    CGContextSaveGState(context);
    CGFloat lineWidth = CGContextConvertSizeToUserSpace(context, (CGSize){self.lineWidth,self.lineWidth}).width;
    CGPathRef pathToFill = CGPathCreateCopyByStrokingPath(thePath, NULL, lineWidth, self.lineCap, self.lineJoin, self.miterLimit);
    CGContextAddPath(context, pathToFill);
    CGContextClip(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradientColors, gradientLocation, 2);
    CGColorSpaceRelease(colorSpace);
    CGPoint gradientStart = thePreviousPoint;
    CGPoint gradientEnd = theCurrentpoint;
    CGContextDrawLinearGradient(context, gradient, gradientStart, gradientEnd, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
}

@end





















