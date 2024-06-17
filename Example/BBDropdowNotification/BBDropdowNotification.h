//
//  BBDropdowNotification.h
//  Delivo
//
//  Created by Bayarbaatar Gonchigsuren on 9/17/19.
//  Copyright © 2019 Premmac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BBDropdowNotificationObject : NSObject

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *subtitleText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) UIBlurEffectStyle backgroundStyle;

@property (nonatomic) BOOL dismissOnTap;
@property (nonatomic) BOOL dismissOnSwipeUp;

@property(nonatomic, assign) CGFloat duration;

@end

@interface BBDropdowNotification : UIView

@property (nonatomic, strong) NSMutableArray* notificationQueue;
@property (nonatomic, strong) BBDropdowNotificationObject* currentObject;

@property (nonatomic, strong) NSTimer* notificationTimer;

@property (nonatomic) BOOL isPresented;

+(BBDropdowNotification *)notification;

/*  public actions  */

/*  Presenting animations   */

//Simple Notification without Image
-(void)presentWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

//Simple Notification with Image
-(void)presentWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;

//Advanced Notification
-(void)presentWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle backgroundStyle:(UIBlurEffectStyle)backgroundStyle dismissOnTap:(BOOL)dismissOnTap dismissOnSwipe:(BOOL)dismissOnSwipe;

/*  Dismissing animations   */

-(void)dismissNotification;

@end
