//
//  WeatherManager.m
//  Digitsole
//
//  Created by Evgeniy on 06/05/2015.
//  Copyright (c) 2015 Glaglashoes. All rights reserved.
//

#import "Weather.h"

#import "UtilitiesManager.h"

@interface Weather ()

@end

@implementation Weather

@synthesize theCity = _theCity;
@synthesize theDescription = _theDescription;
@synthesize theDescriptionIconName = _theDescriptionIconName;
@synthesize theWindSpeed = _theWindSpeed;
@synthesize theDateText = _theDateText;
@synthesize theMainTemperature = _theMainTemperature;
@synthesize theMainPressure = _theMainPressure;
@synthesize theDate = _theDate;
@synthesize theCloudness = _theCloudness;

#pragma mark - Class Methods

+ (void)methodGetHourlyForecastInCoordinate:(CLLocationCoordinate2D)theCoordinate
                        withCompletionBlock:(void (^)(NSArray *theWeatherArray))theBlock;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                   {
                       
                       NSString *theUrlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=metric",
                                                 theCoordinate.latitude, theCoordinate.longitude];
                       NSLog(@"%@", theUrlString);
                       NSData *theResponseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theUrlString]];
                       if (theResponseData)
                       {
                           CLGeocoder *theGeocoder = [[CLGeocoder alloc] init];
                           [theGeocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:theCoordinate.latitude longitude:theCoordinate.longitude]
                                             completionHandler:^(NSArray *placemarks, NSError *error)
                            {
                                NSString *theCity;
                                if (placemarks.count)
                                {
                                    CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                    theCity = placemark.locality;
                                }
                                else
                                {
                                    theCity = @"your city";
                                }
                                
                                NSMutableArray *theCompletionArray = [[NSMutableArray alloc] init];
                                NSDictionary *theResponseDictionary = [NSJSONSerialization JSONObjectWithData:theResponseData options:0 error:nil];
                                NSArray *theArray = theResponseDictionary[@"list"];
                                if (theArray)
                                {
                                    for (NSDictionary *theDictionary in theArray)
                                    {
                                        Weather *theWeather = [[Weather alloc] initWithDictionary:theDictionary andCity:theCity];
                                        [theCompletionArray addObject:theWeather];
                                    }
                                }
                                dispatch_async(dispatch_get_main_queue(), ^
                                               {
                                                   theBlock(theCompletionArray);
                                               });
                            }];
                       }
                       else
                       {
                           dispatch_async(dispatch_get_main_queue(), ^
                           {
                               theBlock(nil);
                           });
                       }
                   });
}

#pragma mark - Init & Dealloc

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"use class methods instead!");
        [UtilitiesManager methodShowErrorInMethod:__PRETTY_FUNCTION__];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)theDictionary andCity:(NSString *)theCity
{
    self = [super init];
    if (self)
    {
        self.theCity = theCity;
        
        NSArray *theWeatherArray = theDictionary[@"weather"];
        NSDictionary *theDescriptionDictionary = theWeatherArray[0];
        self.theDescription = [NSString stringWithFormat:@"%@", theDescriptionDictionary[@"description"]];
        self.theDescriptionIconName = [NSString stringWithFormat:@"%@", theDescriptionDictionary[@"icon"]];
        NSDictionary *theWindDictionary = theDictionary[@"wind"];
        self.theWindSpeed = [NSString stringWithFormat:@"%@", theWindDictionary[@"speed"]];
        self.theDateText = [NSString stringWithFormat:@"%@", theDictionary[@"dt_txt"]];
        NSDictionary *theMainDictionary = theDictionary[@"main"];
        self.theMainTemperature = [NSString stringWithFormat:@"%@", theMainDictionary[@"temp"]];
        self.theMainPressure = [NSString stringWithFormat:@"%@", theMainDictionary[@"pressure"]];
        
        NSDictionary *theCloudsDictionary = theDictionary[@"clouds"];
        self.theCloudness = [NSString stringWithFormat:@"%@", theCloudsDictionary[@"all"]];
        
        NSDateFormatter *theDateFormatter = [[NSDateFormatter alloc] init];
        theDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        self.theDate = [theDateFormatter dateFromString:self.theDateText];
    }
    return self;
}

#pragma mark Setters & Getters

- (void)setTheCity:(NSString *)theFormattedAddress
{
    _theCity = theFormattedAddress;
}

- (void)setTheDescription:(NSString *)theDescription
{
    _theDescription = theDescription;
}

- (void)setTheDescriptionIconName:(NSString *)theDescriptionIconName
{
    _theDescriptionIconName = theDescriptionIconName;
}

- (void)setTheWindSpeed:(NSString *)theWindSpeed
{
    _theWindSpeed = theWindSpeed;
}

- (void)setTheDateText:(NSString *)theDateTxt
{
    _theDateText = theDateTxt;
}

- (void)setTheMainTemperature:(NSString *)theMainTemp
{
    _theMainTemperature = theMainTemp;
}

- (void)setTheMainPressure:(NSString *)theMainPressure
{
    _theMainPressure = theMainPressure;
}

- (void)setTheDate:(NSDate *)theDate
{
    _theDate = theDate;
}

- (void)setTheCloudness:(NSString *)theCloudness
{
    _theCloudness = theCloudness;
}

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Notifications

#pragma mark - Delegates ()

#pragma mark - Methods

#pragma mark - Standard Methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@",
            self.theCity,
            self.theDescription,
            self.theDescriptionIconName,
            self.theWindSpeed,
            self.theDateText, self.theMainTemperature, self.theMainPressure, self.theDate];
}

@end









