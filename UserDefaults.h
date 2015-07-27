//
//  UserDefaults.h
//  SNSales
//
//  Created by Evgeniy on 7/9/15.
//  Copyright (c) 2015 Mobiwolf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define keyDefaultTargetSteps 1500
#define keyDefaultTargetDistance 500 // m
#define keyDefaultTargetKcal 200
#define keyDefaultTargetSpeed 1 // km/h
#define keyDefaultTargetTime 1 // h

@interface UserDefaults : NSObject

@property (nonatomic, assign) NSInteger theTargetSteps;
@property (nonatomic, assign) NSInteger theTargetDistance;
@property (nonatomic, assign) NSInteger theTargetKcal;
@property (nonatomic, assign) NSInteger theTargetSpeed;
@property (nonatomic, assign) NSInteger theTargetTime;

+ (instancetype)sharedInstance;

@end
