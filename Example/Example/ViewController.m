//
//  ViewController.m
//  Example
//
//  Created by Bayarbaatar Gonchigsuren on 6/16/24.
//

#import "ViewController.h"
#import "BBDropdowNotification.h"

@interface ViewController ()

@property(nonatomic, strong) NSArray<NSString *>* randomName;
@property(nonatomic, strong) NSArray<NSString *>* randomText;
@property(nonatomic, strong) NSArray<NSString *>* randomImages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIButton* startButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 180.0, 44.0)];
    [startButton setTitle:@"Show me 📣" forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
    [startButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    startButton.layer.borderColor = [UIColor grayColor].CGColor;
    startButton.layer.borderWidth = 1.0;
    startButton.layer.cornerRadius = 8.0;
    [startButton addTarget:self action:@selector(showRandomNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    startButton.center = self.view.center;

    [self setupRandomValues];
}

-(void)setupRandomValues{
    
    self.randomName = @[@"Your dasher have arrived.", @"BBNotification Example", @"You have a new message", @"Love of my Life 😘"];
    self.randomText = @[@"Tap to open the chat.", @"BBNotification is Awesome and Easy to install. I will thank for the creator 😍", @"You have a new message", @"Love of my Life 😘"];
    self.randomImages = @[@"image", @"image1", @"image2", @"image3"];
    
}

-(void)showRandomNotification{

    NSUInteger nameIndex = arc4random_uniform((unsigned int)[self.randomName count]);
    NSUInteger textIndex = arc4random_uniform((unsigned int)[self.randomText count]);
    NSUInteger imageIndex = arc4random_uniform((unsigned int)[self.randomImages count]);

    NSString* randomTitle = self.randomName[nameIndex];
    NSString* randomText = self.randomText[textIndex];
    NSString* randomImage = self.randomImages[imageIndex];
    
    [[BBDropdowNotification notification] presentWithImage:[UIImage imageNamed:randomImage]
                                                     title:randomTitle
                                                  subtitle:randomText
                                           backgroundStyle:UIBlurEffectStyleExtraLight
                                              dismissOnTap:YES dismissOnSwipe:YES];


}

@end
