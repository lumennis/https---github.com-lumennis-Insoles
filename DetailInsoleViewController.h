//
//  DetailInsoleViewController.h
//  Digitsole
//
//  Created by Evgeniy on 07/05/2015.
//  Copyright (c) 2015 Glaglashoes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailInsoleViewController : UIViewController

@property (nonatomic, assign) int thePairIndex;
@property (nonatomic, assign) BOOL isPairPassed;

- (void)actionRegister:(UIButton *)theButton;

@end





