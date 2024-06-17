//
//  BBDropdowNotification.m
//  Delivo
//
//  Created by Bayarbaatar Gonchigsuren on 9/17/19.
//  Copyright © 2019 Premmac. All rights reserved.
//

#import "BBDropdowNotification.h"
#import "BBConstants.h"

@implementation BBDropdowNotificationObject

@end


static CGFloat kNotificationDefaultMargin = 16.0;
static CGFloat kNotificationDefaultImageRightMargin = 12.0;
static CGFloat kNotificationDefaultTitleFontSize = 14.0;
static CGFloat kNotificationDefaultSubstitleFontSize = 12.0;
static CGFloat kNotificationDefaultImageViewSize = 42.0;
static CGFloat kNotificationDefaultCornerRadius = 20.0;

static CGFloat kNotificationDefaultAnimationDuration    = 0.3;
static CGFloat kNotificationDefaultAnimationDelay       = 0.0;
static CGFloat kNotificationDefaultAnimationVelocity    = 1.0;
static CGFloat kNotificationDefaultAnimationDamping     = 3.0;


@interface BBDropdowNotification (){
    
    UIFont* titleFont;
    UIFont* subtitleFont;
    
    UIColor* titleColor;
    UIColor* subtitleColor;
    
    CGSize screenSize;
}

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation BBDropdowNotification

-(id)init {
    
    self = [super init];
    
    if (self) {
        [self initializeSubViews];
    }
    return self;
}

-(void)initializeSubViews
{
    self.notificationQueue = [NSMutableArray new];
    
    [self updateStyles];
    
    self.layer.cornerRadius = kNotificationDefaultCornerRadius;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:kNotificationDefaultTitleFontSize weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor blackColor];
    
    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.font = [UIFont systemFontOfSize:kNotificationDefaultSubstitleFontSize];
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.textColor = [UIColor darkGrayColor];
    
    self.imageView = [UIImageView new];
    self.imageView.image = nil;
}

-(void)updateStyles
{
    
    screenSize      = [UIScreen mainScreen].bounds.size;
    
    titleFont       = [UIFont systemFontOfSize:kNotificationDefaultTitleFontSize weight:UIFontWeightBold];
    subtitleFont    = [UIFont systemFontOfSize:kNotificationDefaultSubstitleFontSize];
    
    titleColor      = [UIColor blackColor];
    subtitleColor   = [UIColor darkTextColor];
}

/*Presenting animations*/
-(void)presentWithTitle:(NSString *)title subtitle:(NSString *)subtitle
{
    [self presentWithImage:nil title:title subtitle:subtitle];
}

-(void)presentWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle
{
    [self presentWithImage:image title:title subtitle:subtitle backgroundStyle:UIBlurEffectStyleExtraLight dismissOnTap:YES dismissOnSwipe:YES];
}

-(void)presentWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle backgroundStyle:(UIBlurEffectStyle)backgroundStyle dismissOnTap:(BOOL)dismissOnTap dismissOnSwipe:(BOOL)dismissOnSwipe{
    
    BBDropdowNotificationObject* notification = [[BBDropdowNotificationObject alloc] init];
    
    notification.image              = image;
    notification.titleText          = title;
    notification.subtitleText       = subtitle;
    
    notification.backgroundStyle    = backgroundStyle;
    
    notification.dismissOnTap       = dismissOnTap;
    notification.dismissOnSwipeUp   = dismissOnSwipe;
    
    notification.duration           = 3.0f;
    
    [self.notificationQueue addObject:notification];
    
    if (self.currentObject == nil) {
        [self checkQueueAndPlay];
    }
}

-(void)presentCurrentNotificationObject
{
    CGFloat contentWidth    = screenSize.width - (2*kNotificationDefaultMargin);
    CGFloat labelOriginX    = self.currentObject.image == nil ? kNotificationDefaultMargin : kNotificationDefaultMargin + kNotificationDefaultImageRightMargin + kNotificationDefaultImageViewSize;
    CGFloat labelWidth      = contentWidth - labelOriginX - kNotificationDefaultMargin;
    
    CGFloat titleHeight = [self.currentObject.titleText boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: titleFont} context:nil].size.height;
    CGFloat subtitleHeight = [self.currentObject.subtitleText boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: subtitleFont} context:nil].size.height;
    
    
    CGFloat calculatedHeight  = (kNotificationDefaultMargin + titleHeight + 2.0 + subtitleHeight + kNotificationDefaultMargin);
    CGFloat minimumHeight       = self.currentObject.image == nil ? 0.0 : (2 * kNotificationDefaultMargin) + kNotificationDefaultImageViewSize;
    
    CGFloat notificationHeight  = calculatedHeight < minimumHeight ? minimumHeight : calculatedHeight;
    CGRect  notificationFrame   = CGRectMake(kNotificationDefaultMargin, - notificationHeight, contentWidth, notificationHeight);
    
    
    self.titleLabel.frame = CGRectMake(labelOriginX, kNotificationDefaultMargin, labelWidth, titleHeight);
    self.subtitleLabel.frame = CGRectMake(labelOriginX, kNotificationDefaultMargin + titleHeight + 2.0, labelWidth, subtitleHeight);
    
    [self setAlpha:0.0];
    [self setFrame:notificationFrame];
    [self addSubview:[self backgroundViewWithBlurStyle:self.currentObject.backgroundStyle]];

    if (self.currentObject.image)
    {
        self.imageView.frame = CGRectMake(kNotificationDefaultMargin,kNotificationDefaultMargin, kNotificationDefaultImageViewSize, kNotificationDefaultImageViewSize);
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    
    //Gesture recognizers
    if (self.currentObject.dismissOnTap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotificationByUser)];
        [self addGestureRecognizer:tap];
    }
    
    if (self.currentObject.dismissOnSwipeUp) {
        UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotificationByUser)];
        swipe.direction = UISwipeGestureRecognizerDirectionUp ;
        [self addGestureRecognizer:swipe];
    }

    [self showNotificationWithAnimated];
}

-(void)showNotificationWithAnimated
{
    
    self.titleLabel.text    = self.currentObject.titleText;
    self.subtitleLabel.text = self.currentObject.subtitleText;
    self.imageView.image    = self.currentObject.image;
    
    self.userInteractionEnabled = YES;
    
    CGRect notificationFrame = self.frame;
    notificationFrame.origin.y = IS_IPHONEX ? 44.0 : 20.0;
    
    [UIView animateWithDuration:kNotificationDefaultAnimationDuration
                          delay:kNotificationDefaultAnimationDelay
         usingSpringWithDamping:kNotificationDefaultAnimationVelocity
          initialSpringVelocity:kNotificationDefaultAnimationDamping
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.alpha = 1.0;
                            self.frame = notificationFrame;
                            
                        } completion:^(BOOL finished) {
                            self.isPresented = YES;
                            self.notificationTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentObject.duration
                                                                                 target:self selector:@selector(dismissNotification)
                                                                               userInfo:nil repeats:NO];
                            
                        }];
}

-(void)dismissNotificationByUser
{
    [self dismissNotification];
    
}

-(void)dismissNotification
{
    
    CGRect notificationFrame = self.frame;
    notificationFrame.origin.y = -notificationFrame.size.height;
    
    [UIView animateWithDuration:kNotificationDefaultAnimationDuration
                          delay:kNotificationDefaultAnimationDelay
         usingSpringWithDamping:kNotificationDefaultAnimationVelocity
          initialSpringVelocity:kNotificationDefaultAnimationDamping
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{

                            self.alpha = 0.0;
                            self.frame = notificationFrame;

                        } completion:^(BOOL finished) {
                            
                            [self.notificationTimer invalidate];
                            self.notificationTimer = nil;

                            [self.notificationQueue removeObject:self.currentObject];
                            [self removeSubviews];
                            
                            self.isPresented = NO;
                            
                            [self checkQueueAndPlay];
                        }];
}

-(void)checkQueueAndPlay
{
    if (self.notificationQueue.count > 0) {
        
        self.currentObject = [self.notificationQueue firstObject];
        [self presentCurrentNotificationObject];
        return;
    }
//    NSLog(@"no next notification");

    self.currentObject = nil;
}

-(void)removeSubviews {
    
    for (UIView *subiew in self.subviews) {
        [subiew removeFromSuperview];
    }
    self.alpha = 0.0;
//    self.userInteractionEnabled = NO;
}

-(UIVisualEffectView *)backgroundViewWithBlurStyle:(UIBlurEffectStyle)style
{
    UIVisualEffect *visualEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
    blurView.frame = self.bounds;
    
    return blurView;

}

+(BBDropdowNotification *)notification
{
    static BBDropdowNotification *_sharedClient = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;

}

@end
