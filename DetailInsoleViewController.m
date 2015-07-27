//
//  DetailInsoleViewController.m
//  Digitsole
//
//  Created by Evgeniy on 07/05/2015.
//  Copyright (c) 2015 Glaglashoes. All rights reserved.
//

#import "DetailInsoleViewController.h"
#import "Constants.h"
#import "SettingsViewController.h"
#import "Utils.h"
#import "SolePair.h"
#import "MainTabbarController.h"
#import "UtilitiesManager.h"

#define definedNumberOfComponents 1
#define definedRowHeight 40
#define definedRowWidth 180

#define definedNumberOfRowsMeters 220
#define definedNumberOfRowsFeet 70
#define definedNumberOfRowsKilograms 150
#define definedNumberOfRowsLbs 400

typedef enum : int
{
    SegmentedControlNone = 0,
    SegmentedControlDistance ,
    SegmentedControlTemperature,
    SegmentedControlWeight
} SegmentedControl;

typedef enum: int
{
    PickerViewNone = 0,
    PickerViewHeight,
    PickerViewWeight
} thePickerView;

typedef enum : int
{
    GenderSegmentNone = 0,
    GenderSegmentWoman,
    GenderSegmentMan
} GenderSegment;

@interface DetailInsoleViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>
{
    BOOL isFirstLoad;
    UITextField *theNameTextField;
    UIPickerView *theHeightPickerView;
    UIPickerView *theWeightPickerView;
    
    UIButton *theGenderButton;
    UIButton *theRegisterButton;
    UIButton *theDoneButton;
    UIButton *theForgetButton;
    
    UIView *theCoverView;
    UIImageView *theBackgroundView;
    
    UILabel *theNameLabel;
    UILabel *theHeightLabel;
    UILabel *theWeightLabel;
    UILabel *theMeasureHeightLabel;
    UILabel *theMeasureWeightLabel;
    UILabel *theDistanceButtonLabel;
    UILabel *theTemperatureButtonLabel;
    UILabel *theWeigthButtonLabel;
}

@end

@implementation DetailInsoleViewController

#pragma mark - Class Methods

#pragma mark - Init & Dealloc

- (void)dealloc
{
    [UtilitiesManager methodSetStatusBarHidden:NO];
}

#pragma mark Setters & Getters

#pragma mark - Lifecycle

- (void)loadView
{
    [super loadView];
    isFirstLoad = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        [self createBackground];
        [self createPickerView:PickerViewHeight];
        [self createPickerView:PickerViewWeight];
        [self createNameTextField];
        [self createSegmentedControl:SegmentedControlDistance];
        [self createSegmentedControl:SegmentedControlTemperature];
        [self createSegmentedControl:SegmentedControlWeight];
        [self createGenderButton];
        
        if (self.isPairPassed)
        {
            [self createDoneButton];
            [self createForgetButton];
            [MainTabbarController methodAddLogoToView:self.view];
            [UtilitiesManager methodSetStatusBarHidden:YES];
        }
        
        [self methodHideCoverView];
        [self methodRefreshDisplayForPickerView:theHeightPickerView];
        [self methodRefreshDisplayForPickerView:theWeightPickerView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Create Views & Variables

- (void)createBackground
{
    theBackgroundView = [[UIImageView alloc]init];
    theBackgroundView.image = [UIImage imageConsideringPhone:@"registration_menu"];
    theBackgroundView.frame = CGRectMake(0,
                                      [MainTabbarController sharedInstance].theTopOffset,
                                      theBackgroundView.image.size.width,
                                      theBackgroundView.image.size.height);
    [self.view addSubview:theBackgroundView];
}

- (void)createDoneButton
{
    theDoneButton = [[UIButton alloc] init];
    [theDoneButton setBackgroundImage:[UIImage imageConsideringPhone:@"button_start_search"] forState:UIControlStateNormal];
    [theDoneButton methodSetImageFrame];
    theDoneButton.center = CGPointMake(self.view.frame.size.width*0.25,
                                       self.view.frame.size.height - theDoneButton.frame.size.height/2 - [MainTabbarController theDefaultOffset]);
    theDoneButton.titleLabel.font = [MainTabbarController theDefaultFont];
    [theDoneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [theDoneButton addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:theDoneButton];
}

- (void)createForgetButton
{
    theForgetButton = [[UIButton alloc] init];
    [theForgetButton setBackgroundImage:[UIImage imageConsideringPhone:@"button_start_search"] forState:UIControlStateNormal];
    [theForgetButton methodSetImageFrame];
    theForgetButton.center = CGPointMake(self.view.frame.size.width*0.75,
                                         self.view.frame.size.height - theForgetButton.frame.size.height/2 - [MainTabbarController theDefaultOffset]);
    theForgetButton.titleLabel.font = [MainTabbarController theDefaultFont];
    [theForgetButton setTitle:@"DELETE" forState:UIControlStateNormal];
    [theForgetButton addTarget:self action:@selector(actionForgetPair:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:theForgetButton];
}

- (void)createNameTextField
{
    int theTopOffset = 0;
    int theLeftOffset = 0;
    switch ([UtilitiesManager theDevice])
    {
        case DeviceiPhone4:
            theTopOffset += 86;
            theLeftOffset += 135;
            break;
        case DeviceiPhone5:
            theTopOffset += 86;
            theLeftOffset += 135;
            break;
        case DeviceiPhone6:
            theTopOffset += 103;
            theLeftOffset += 148;
            break;
        case DeviceiPhone6Plus:
            theTopOffset += 113;
            theLeftOffset += 172;
            break;
        default:
            [UtilitiesManager methodShowErrorInMethod:__PRETTY_FUNCTION__];
    }
    
    theNameTextField = [[UITextField alloc] init];
    theNameTextField.frame = CGRectMake(0, 0, self.view.frame.size.width - [MainTabbarController theDefaultOffset] - theLeftOffset, 40);
    theNameTextField.center = CGPointMake(theNameTextField.frame.size.width/2 + theLeftOffset, theTopOffset);
    theNameTextField.font = [MainTabbarController theDefaultFont];
    theNameTextField.delegate = self;
    [self.view addSubview:theNameTextField];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [MainTabbarController theDefaultFont];
    nameLabel.frame = CGRectMake(0, 0, 100, 30);
    nameLabel.center = CGPointMake([MainTabbarController theDefaultOffset] + nameLabel.center.x, theTopOffset);
    nameLabel.text = @"NAME";
    theNameLabel = nameLabel;
    [self.view addSubview:theNameLabel];
}

- (void)createGenderButton
{
    int theTopOffset = 0;
    switch ([UtilitiesManager theDevice])
    {
        case DeviceiPhone4:
            theTopOffset += 135;
            break;
        case DeviceiPhone5:
            theTopOffset += 142;
            break;
        case DeviceiPhone6:
            theTopOffset += 168;
            break;
        case DeviceiPhone6Plus:
            theTopOffset += 186;
            break;
        default:
            [UtilitiesManager methodShowErrorInMethod:__PRETTY_FUNCTION__];
    }
    
    theGenderButton = [[UIButton alloc] init];
    [theGenderButton setBackgroundImage:[UIImage imageConsideringPhone:@"switch_gender_left"] forState:UIControlStateNormal];
    
    if (self.isPairPassed)
    {
        NSMutableArray *theArray = [[NSUserDefaults standardUserDefaults] arrayForKey:KEY_REGISTERED_PAIRS].mutableCopy;
        NSMutableDictionary *theDictionary = ((NSDictionary *)theArray[self.thePairIndex]).mutableCopy;
        if ([theDictionary[KEY_GENDER] boolValue])
        {
            [self actionGenderSwitch:theGenderButton];
        }
    }
    [theGenderButton methodSetImageFrame];
    theGenderButton.center = CGPointMake(self.view.center.x, theTopOffset);
    theGenderButton.titleLabel.font = [MainTabbarController theDefaultFont];
    [theGenderButton setTitle:@"    MAN       WOMAN" forState:UIControlStateNormal];
    theGenderButton.adjustsImageWhenHighlighted = NO;
    [theGenderButton addTarget:self action:@selector(actionGenderSwitch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:theGenderButton];
}

- (void)createSegmentedControl:(SegmentedControl)theSegmentedControlIndex
{
    int theTopOffset = - [UIImage imageConsideringPhone:@"down_bar_warm_on"].size.height;
    int theLeftOffset = 0;
    switch ([UtilitiesManager theDevice])
    {
        case DeviceiPhone4:
            theLeftOffset += 16;
            break;
        case DeviceiPhone5:
            theLeftOffset += 16;
            break;
        case DeviceiPhone6:
            theLeftOffset += 19;
            break;
        case DeviceiPhone6Plus:
            theLeftOffset += 20;
            break;
        default:
            break;
    }
    
    switch (theSegmentedControlIndex)
    {
        case SegmentedControlDistance:
        {
            switch ([UtilitiesManager theDevice])
            {
                case DeviceiPhone4:
                    theTopOffset += 395;
                    break;
                case DeviceiPhone5:
                    theTopOffset += 443;
                    break;
                case DeviceiPhone6:
                    theTopOffset += 520;
                    break;
                case DeviceiPhone6Plus:
                    theTopOffset += 570;
                    break;
                default:
                    break;
            }
            break;
        }
        case SegmentedControlTemperature:
        {
            switch ([UtilitiesManager theDevice])
            {
                case DeviceiPhone4:
                    theTopOffset += 435;
                    break;
                case DeviceiPhone5:
                    theTopOffset += 483;
                    break;
                case DeviceiPhone6:
                    theTopOffset += 566;
                    break;
                case DeviceiPhone6Plus:
                    theTopOffset += 620;
                    break;
                default:
                    break;
            }
            break;
        }
        case SegmentedControlWeight:
        {
            switch ([UtilitiesManager theDevice])
            {
                case DeviceiPhone4:
                    theTopOffset += 475;
                    break;
                case DeviceiPhone5:
                    theTopOffset += 523;
                    break;
                case DeviceiPhone6:
                    theTopOffset += 612;
                    break;
                case DeviceiPhone6Plus:
                    theTopOffset += 670;
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            [UtilitiesManager methodShowErrorInMethod:__PRETTY_FUNCTION__];
    }
    
    UIButton *theButton = [[UIButton alloc] init];
    theButton.tag = theSegmentedControlIndex;
    [theButton setBackgroundImage:[UIImage imageConsideringPhone:@"switch_right"] forState:UIControlStateNormal];
    theButton.frame = CGRectMake(self.view.frame.size.width - theButton.currentBackgroundImage.size.width,
                                 0,
                                 theButton.currentBackgroundImage.size.width,
                                 theButton.currentBackgroundImage.size.height);
    theButton.center = CGPointMake(theButton.center.x, theTopOffset);
    [theButton addTarget:self action:@selector(actionMeasureSwitch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    theButton.titleLabel.font = [MainTabbarController theDefaultFont];
//    theButton.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:theButton];
    
    UILabel *theLabel = [[UILabel alloc] init];
    theLabel.frame = CGRectMake(theLeftOffset, 0, CGRectGetMinX(theButton.frame), 30);
    theLabel.center = CGPointMake(theLabel.center.x, theTopOffset);
    theLabel.font = [MainTabbarController theDefaultFont];
    [self.view addSubview:theLabel];
    
    switch (theSegmentedControlIndex)
    {
        case SegmentedControlDistance:
            theButton.adjustsImageWhenDisabled = [MainTabbarController sharedInstance].isMeters;
            [theButton setTitle:@"M      FT" forState:UIControlStateNormal];
            theLabel.text = @"DISTANCE";
            break;
        case SegmentedControlTemperature:
            theButton.adjustsImageWhenDisabled = [MainTabbarController sharedInstance].isCelsius;
            [theButton setTitle:@"°C      °F" forState:UIControlStateNormal];
            theLabel.text = @"TEMPERATURE";
            break;
        case SegmentedControlWeight:
            theButton.adjustsImageWhenDisabled = [MainTabbarController sharedInstance].isKilograms;
            [theButton setTitle:@"KG     LBS" forState:UIControlStateNormal];
            theLabel.text = @"WEIGHT";
            break;
        default:
            [UtilitiesManager methodShowErrorInMethod:__PRETTY_FUNCTION__];
    }
    if (theButton.adjustsImageWhenDisabled)
    {
        [theButton setBackgroundImage:[UIImage imageConsideringPhone:@"switch_left"] forState:UIControlStateNormal];
    }
}

- (void)createPickerView:(thePickerView)thePickerViewIndex
{
    int theLeftOffset = 0;
    int theTopOffset = 0;
    switch ([UtilitiesManager theDevice])
    {
        case DeviceiPhone4:
            theTopOffset += (thePickerViewIndex == PickerViewHeight ? 194 : 272);
            theLeftOffset += 220;
            break;
        case DeviceiPhone5:
            theTopOffset += (thePickerViewIndex == PickerViewHeight ? 220 : 305);
            theLeftOffset += 220;
            break;
        case DeviceiPhone6:
            theTopOffset += (thePickerViewIndex == PickerViewHeight ? 260 : 360);
            theLeftOffset += 256;
            break;
        case DeviceiPhone6Plus:
            theTopOffset += (thePickerViewIndex == PickerViewHeight ? 285 : 395);
            theLeftOffset += 284;
            break;
        default:
            [UtilitiesManager methodShowErrorInMethod:__PRETTY_FUNCTION__];
    }
    
    UIPickerView *thePickerView = [[UIPickerView alloc] init];
    thePickerView.center = CGPointMake(theLeftOffset, theTopOffset);
    thePickerView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    thePickerView.dataSource = self;
    thePickerView.delegate = self;
    [self.view insertSubview:thePickerView belowSubview:theBackgroundView];
    
    UILabel *theLeftLabel = [[UILabel alloc] init];
    theLeftLabel.frame = CGRectMake(0, 0, 200, 30);
    theLeftLabel.center = CGPointMake([MainTabbarController theDefaultOffset] + theLeftLabel.center.x, theTopOffset);
    theLeftLabel.font = [MainTabbarController theDefaultFont];
    [self.view addSubview:theLeftLabel];
    
    UILabel *theRightLabel = [[UILabel alloc] init];
    theRightLabel.frame = CGRectMake(0, 0, 50, 30);
    theRightLabel.center = CGPointMake(thePickerView.center.x + thePickerView.frame.size.width/3 + [MainTabbarController theDefaultOffset], theTopOffset);
    theRightLabel.font = [MainTabbarController theDefaultFont];
    [self.view addSubview:theRightLabel];
    
    switch (thePickerViewIndex)
    {
        case PickerViewHeight:
            theHeightPickerView = thePickerView;
            theLeftLabel.text = @"HEIGHT";
            theHeightLabel = theLeftLabel;
            theMeasureHeightLabel = theRightLabel;
            break;
        case PickerViewWeight:
            theWeightPickerView = thePickerView;
            theLeftLabel.text = @"WEIGHT";
            theWeightLabel = theLeftLabel;
            theMeasureWeightLabel = theRightLabel;
            break;
        default:
            [UtilitiesManager methodShowErrorInMethod:__PRETTY_FUNCTION__];
    }
}

- (void)createCoverView
{
    theCoverView = [[UIView alloc] init];
    theCoverView.frame = CGRectMake (0, 0, self.view.frame.size.width, self.view.frame.size.height);
    theCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:theCoverView];
}

#pragma mark - Actions

- (void)actionGenderSwitch:(UIButton *)theButton
{
    theButton.adjustsImageWhenDisabled = !theButton.adjustsImageWhenDisabled;
    [theButton setBackgroundImage:[UIImage imageConsideringPhone:theButton.adjustsImageWhenDisabled ? @"switch_gender_left" : @"switch_gender_right"] forState:UIControlStateNormal];
}

- (void)actionMeasureSwitch:(UIButton *)theButton
{
    theButton.adjustsImageWhenDisabled = !theButton.adjustsImageWhenDisabled;
    [theButton setBackgroundImage:[UIImage imageConsideringPhone:theButton.adjustsImageWhenDisabled ? @"switch_left" : @"switch_right"] forState:UIControlStateNormal];
    switch (theButton.tag)
    {
        case SegmentedControlDistance:
            [MainTabbarController sharedInstance].isMeters = ![MainTabbarController sharedInstance].isMeters;
            [theHeightPickerView reloadAllComponents];
            [self methodRefreshDisplayForPickerView:theHeightPickerView];
            break;
        case SegmentedControlTemperature:
            [MainTabbarController sharedInstance].isCelsius = ![MainTabbarController sharedInstance].isCelsius;
            return;
            break;
        case SegmentedControlWeight:
            [MainTabbarController sharedInstance].isKilograms = ![MainTabbarController sharedInstance].isKilograms;
            [theWeightPickerView reloadAllComponents];
            [self methodRefreshDisplayForPickerView:theWeightPickerView];
            break;
        default:
            [UtilitiesManager methodShowErrorInMethod:__PRETTY_FUNCTION__];
            break;
    }
}

- (void)actionDone:(UIButton *)theButton
{
    NSString *theName = theNameTextField.text;
    theName = [theName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([theName isEqual:@""])
    {
        [self methodShowNameError];
        return;
    }
    
    NSMutableArray *theArray = [[NSUserDefaults standardUserDefaults] arrayForKey:KEY_REGISTERED_PAIRS].mutableCopy;
    NSMutableDictionary *theDictionary = ((NSDictionary *)theArray[self.thePairIndex]).mutableCopy;
    
    theDictionary[KEY_NAME] = theNameTextField.text;
    theDictionary[KEY_GENDER] = @(!theGenderButton.adjustsImageWhenDisabled);
    
    NSInteger theRowHeight = [theHeightPickerView selectedRowInComponent:0];
    theDictionary[KEY_HEIGHT_CM] = @([MainTabbarController sharedInstance].isMeters ? (float)theRowHeight : [Utils methodConvertFootToMeters:10.0f*theRowHeight]);
    NSInteger theRowWeight = [theWeightPickerView selectedRowInComponent:0];
    theDictionary[KEY_WEIGHT_KG] = @([MainTabbarController sharedInstance].isKilograms ? (float)theRowWeight : [Utils methodConvertPoundsToKilograms:theRowWeight]);
    
    [theArray replaceObjectAtIndex:self.thePairIndex withObject:theDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:theArray forKey:KEY_REGISTERED_PAIRS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionForgetPair:(UIButton *)theButton
{
    UIAlertController *theAlertController = [UIAlertController alertControllerWithTitle:@"WARNING"
                                                                                message:@"Are you sure that you want to delete this pair?"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *theNoAction = [UIAlertAction actionWithTitle:@"No"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    [theAlertController addAction:theNoAction];
    UIAlertAction *theYesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       [SolePair deletePairAtIndex:self.thePairIndex];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
    [theAlertController addAction:theYesAction];
    [self presentViewController:theAlertController animated:YES completion:nil];
}

- (void)actionRegister:(UIButton *)btn
{
    NSString *theName = theNameTextField.text;
    theName = [theName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([theName isEqual:@""])
    {
        [self methodShowNameError];
        return;
    }
    
    NSInteger theRowOfHeightPicker = [theHeightPickerView selectedRowInComponent:0];
    float theHeight = [MainTabbarController sharedInstance].isMeters ? (float)theRowOfHeightPicker : [Utils methodConvertFootToMeters:10.0f*theRowOfHeightPicker];
    NSInteger theRowOfWeightPicker = [theWeightPickerView selectedRowInComponent:0];
    float theWeight = [MainTabbarController sharedInstance].isMeters ? (float)theRowOfWeightPicker : [Utils methodConvertPoundsToKilograms:theRowOfWeightPicker];
    
    NSDictionary *theDictionary = @{KEY_NAME : theNameTextField.text,
                                    KEY_GENDER : @(!theGenderButton.selected),
                                    KEY_UUIDS : @[[MainTabbarController sharedInstance].theLeftUUID,[MainTabbarController sharedInstance].theRightUUID],
                                    KEY_WEIGHT_KG : @(theWeight),
                                    KEY_HEIGHT_CM : @(theHeight)};
    
    NSMutableArray *theArray = [[NSMutableArray alloc] init];
    [theArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] arrayForKey:KEY_REGISTERED_PAIRS]];
    [theArray addObject:theDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:theArray forKey:KEY_REGISTERED_PAIRS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SolePair setSelectedPairIndex:(int)(theArray.count - 1)];
    [[MainTabbarController sharedInstance].navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Gestures

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch = event.allTouches.anyObject;
    if (theTouch.view == theCoverView)
    {
        [self methodHideCoverView];
    }
}

#pragma mark - Notifications

#pragma mark - Delegates (UIPickerViewDataSource, UIPickerViewDelegate)

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return definedNumberOfComponents;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return definedRowHeight;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return definedRowWidth;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == theHeightPickerView)
    {
        return [MainTabbarController sharedInstance].isMeters ? definedNumberOfRowsMeters : definedNumberOfRowsFeet;
    }
    else
    {
        return [MainTabbarController sharedInstance].isKilograms ? definedNumberOfRowsKilograms : definedNumberOfRowsLbs;
    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.frame = CGRectMake(0, 0, definedRowWidth, 0);
        pickerLabel.textColor = [UIColor blackColor];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont fontWithName:[MainTabbarController theDefaultFontName] size:[MainTabbarController theDefaultFontSize]*2 + 5];
        if (pickerView == theHeightPickerView && ![MainTabbarController sharedInstance].isMeters)
        {
            pickerLabel.text = [NSString stringWithFormat:@"%0.1f", 0.1f*row];
        }
        else
        {
            pickerLabel.text = [NSString stringWithFormat:@"%zd", row];
        }
        pickerLabel.backgroundColor = [UIColor whiteColor];
    }
    return pickerLabel;
}

#pragma mark - Delegates (UITextFieldDelegate)

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self methodShowCoverView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self methodHideCoverView];
    return NO;
}

#pragma mark - Methods

- (void)methodShowNameError
{
    UIAlertController *theAlertController = [UIAlertController alertControllerWithTitle:@"ERROR"
                                                                                message:@"Please, enter your name"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *theAction = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action)
                                {
                                    [theNameTextField becomeFirstResponder];
                                }];
    [theAlertController addAction:theAction];
    [self presentViewController:theAlertController animated:YES completion:nil];
}

- (void)methodShowCoverView
{
    theCoverView.hidden = NO;
}

- (void)methodHideCoverView
{
    theCoverView.hidden = YES;
    [theNameTextField resignFirstResponder];
}

- (void)methodRefreshDisplayForPickerView:(UIPickerView *)thePickerView
{
    if (self.isPairPassed)
    {
        NSMutableArray *theArray = [[NSUserDefaults standardUserDefaults] arrayForKey:KEY_REGISTERED_PAIRS].mutableCopy;
        NSMutableDictionary *theDictionary = ((NSDictionary *)theArray[self.thePairIndex]).mutableCopy;
        theNameTextField.text = theDictionary[KEY_NAME];
        
        if (thePickerView == theHeightPickerView)
        {
            float theHeight = ((NSNumber *)theDictionary[KEY_HEIGHT_CM]).floatValue;
            [thePickerView selectRow:[MainTabbarController sharedInstance].isMeters ? theHeight : (int)([Utils methodConvertMetersToFoot:(float)theHeight/10])
                         inComponent:0
                            animated:NO];
            theMeasureHeightLabel.text = [MainTabbarController sharedInstance].isMeters ? @"CM" : @"FT";
        }
        else
        {
            float theWeight = ((NSNumber *)theDictionary[KEY_WEIGHT_KG]).floatValue;
            [thePickerView selectRow:[MainTabbarController sharedInstance].isKilograms ? theWeight : (int)([Utils methodConvertKilogramsToPounds:theWeight])
                         inComponent:0
                            animated:NO];
            [theMeasureWeightLabel setText:([MainTabbarController sharedInstance].isKilograms ? @"KG" : @"LBS")];
        }
    }
    else
    {
        theNameTextField.placeholder = @"enter your name";
        theMeasureHeightLabel.text = NSLocalizedString([MainTabbarController sharedInstance].isMeters ? @"CM" : @"FT", nil);
        theMeasureWeightLabel.text = NSLocalizedString([MainTabbarController sharedInstance].isKilograms ? @"KG" : @"LBS", nil);
        if (thePickerView == theHeightPickerView)
        {
            [thePickerView selectRow:([MainTabbarController sharedInstance].isMeters ? 170 : 59) inComponent:0 animated:NO];
        }
        if (thePickerView == theWeightPickerView)
        {
            [thePickerView selectRow:([MainTabbarController sharedInstance].isKilograms ? 50 : 90) inComponent:0 animated:NO];
        }
    }
}

#pragma mark - Standard Methods

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    
}

@end

















