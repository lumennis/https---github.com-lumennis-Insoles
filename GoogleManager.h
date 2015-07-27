//
//  GoogleManager.h
//  Digitsole
//
//  Created by Evgeniy on 19/05/15.
//  Copyright (c) 2015 Glaglashoes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

typedef void (^theCompletionBlock)(CLLocationCoordinate2D theCoordinate);

@interface GoogleManager : NSObject

+ (void)methodGetCoordinateOfAddress:(NSString *)theAddress withCompletionBlock:(theCompletionBlock)theBlock;

@end
