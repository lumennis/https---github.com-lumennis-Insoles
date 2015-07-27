//
//  UserDefaults.m
//  SNSales
//
//  Created by Evgeniy on 7/9/15.
//  Copyright (c) 2015 Mobiwolf. All rights reserved.
//

#import "UserDefaults.h"

#define keyTargetSteps @"targetSteps"
#define keyTargetDistance @"targetDistance"
#define keyTargetKcal @"targetKcal"
#define keyTargetSpeed @"targetSpeed"
#define keyTargetTime @"targetTime"

@interface UserDefaults ()
{
    NSUserDefaults *theUserDefaults;
}

@end

@implementation UserDefaults

static UserDefaults *theSharedInstance;

#pragma mark - Class Methods

+ (instancetype)sharedInstance
{
    @synchronized(self)
    {
        if (!theSharedInstance)
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^
                          {
                              theSharedInstance = [[UserDefaults alloc] init];
                          });
        }
    }
    return theSharedInstance;
}

#pragma mark - Init & Dealloc

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self methodInitUserDefaults];
    }
    return self;
}

#pragma mark - Setters & Getters

- (void)setTheTargetSteps:(NSInteger)theTargetSteps
{
    [theUserDefaults setInteger:theTargetSteps forKey:keyTargetSteps];
    [theUserDefaults synchronize];
}

- (NSInteger)theTargetSteps
{
    if (![theUserDefaults integerForKey:keyTargetSteps])
    {
        self.theTargetSteps = keyDefaultTargetSteps;
    }
    return [theUserDefaults integerForKey:keyTargetSteps];
}

- (void)setTheTargetDistance:(NSInteger)theTargetDistance
{
    [theUserDefaults setInteger:theTargetDistance forKey:keyTargetDistance];
    [theUserDefaults synchronize];
}

- (NSInteger)theTargetDistance
{
    if (![theUserDefaults integerForKey:keyTargetDistance])
    {
        self.theTargetDistance = keyDefaultTargetDistance;
    }
    return [theUserDefaults integerForKey:keyTargetDistance];
}

- (void)setTheTargetKcal:(NSInteger)theTargetKcal
{
    [theUserDefaults setInteger:theTargetKcal forKey:keyTargetKcal];
    [theUserDefaults synchronize];
}

- (NSInteger)theTargetKcal
{
    if (![theUserDefaults integerForKey:keyTargetKcal])
    {
        self.theTargetKcal = keyDefaultTargetKcal;
    }
    return [theUserDefaults integerForKey:keyTargetKcal];
}

- (void)setTheTargetSpeed:(NSInteger)theTargetSpeed
{
    [theUserDefaults setInteger:theTargetSpeed forKey:keyTargetSpeed];
    [theUserDefaults synchronize];
}

- (NSInteger)theTargetSpeed
{
    if (![theUserDefaults integerForKey:keyTargetSpeed])
    {
        self.theTargetSpeed = keyDefaultTargetSpeed;
    }
    return [theUserDefaults integerForKey:keyTargetSpeed];
}

- (void)setTheTargetTime:(NSInteger)theTargetTime
{
    [theUserDefaults setInteger:theTargetTime forKey:keyTargetTime];
    [theUserDefaults synchronize];
}

- (NSInteger)theTargetTime
{
    if (![theUserDefaults integerForKey:keyTargetTime])
    {
        self.theTargetTime = keyDefaultTargetTime;
    }
    return [theUserDefaults integerForKey:keyTargetTime];
}

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Notifications

#pragma mark - Delegates ()

#pragma mark - Methods

- (void)methodInitUserDefaults
{
    theUserDefaults = [NSUserDefaults standardUserDefaults];
}

#pragma mark - Standard Methods

@end







































