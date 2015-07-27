//
//  WeatherManager.h
//  Digitsole
//
//  Created by Evgeniy on 06/05/2015.
//  Copyright (c) 2015 Glaglashoes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface Weather : NSObject

@property (nonatomic, readonly, strong) NSString *theCity;
@property (nonatomic, readonly, strong) NSString *theDescription;
@property (nonatomic, readonly, strong) NSString *theDescriptionIconName;
@property (nonatomic, readonly, strong) NSString *theWindSpeed;
@property (nonatomic, readonly, strong) NSString *theDateText;
@property (nonatomic, readonly, strong) NSString *theMainTemperature;
@property (nonatomic, readonly, strong) NSString *theMainPressure;
@property (nonatomic, readonly, strong) NSString *theCloudness;
@property (nonatomic, readonly, strong) NSDate *theDate;

+ (void)methodGetHourlyForecastInCoordinate:(CLLocationCoordinate2D)theCoordinate
                        withCompletionBlock:(void (^)(NSArray *theWeatherArray))theBlock;

@end
