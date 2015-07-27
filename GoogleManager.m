//
//  GoogleManager.m
//  Digitsole
//
//  Created by Evgeniy on 19/05/15.
//  Copyright (c) 2015 Glaglashoes. All rights reserved.
//

#import "GoogleManager.h"

@implementation GoogleManager

+ (void)methodGetCoordinateOfAddress:(NSString *)theAddress
                withCompletionBlock:(theCompletionBlock)theBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                   {
                       NSString *theUrlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@", theAddress];
                       theUrlString = [theUrlString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
                       
                       CLLocationCoordinate2D theLocation = CLLocationCoordinate2DMake(0, 0);
                       NSData *theResponseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theUrlString]];
                       if (theResponseData)
                       {
                           NSDictionary *theResponseDictionary = [NSJSONSerialization JSONObjectWithData:theResponseData options:0 error:nil];
                           NSArray *theResultsArray = theResponseDictionary[@"results"];
                           if (theResultsArray.count)
                           {
                               NSDictionary *theResultDictionary = theResultsArray[0];
                               NSDictionary *theGeometryDictionary = theResultDictionary[@"geometry"];
                               NSDictionary *theLocationDictionary = theGeometryDictionary[@"location"];
                               NSString *theLatitude = theLocationDictionary[@"lat"];
                               NSString *theLongitude = theLocationDictionary[@"lng"];
                               theLocation = CLLocationCoordinate2DMake(theLatitude.doubleValue, theLongitude.doubleValue);
                           }
                       }
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          theBlock(theLocation);
                                      });
                   });
}

@end
