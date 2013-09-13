//
//  Post2ViewController.h
//  ISU
//
//  Created by MUU KOJIMA on 9/9/13.
//  Copyright (c) 2013 MUU KOJIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#define PATH @"http://172.30.254.1" 
#define IP @"192.168.11.9"
#define IP2 @"172.30.254.1"

@protocol Post2ViewControllerDelegate;
@interface Post2ViewController : UIViewController<UITextFieldDelegate>
/*{
    UIImageView *pic2;
    
}*/




//UImageView
@property (strong, nonatomic) IBOutlet UIImageView *pic;

//いったんUImageViewに表示するために、空にする
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) id<Post2ViewControllerDelegate> delegate;

//キャッチフレーズ
@property (strong, nonatomic) IBOutlet UITextField *phrase;
//コメント
@property (strong, nonatomic) IBOutlet UITextField *comment;

- (void) PostImage:(UIImage*)image title:(NSString*)title comment:(NSString*)comment lati:(float)lati langi:(float)langi;

@end

@protocol Post2ViewControllerDelegate
- (void)setCoordinate:(CLLocationCoordinate2D)_coordinate title:(NSString*)title snip:(NSString*)snip id:(int)spot_id;

@end