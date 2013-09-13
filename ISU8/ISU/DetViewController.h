//
//  DetViewController.h
//  ISU
//
//  Created by admin on 2013/09/12.
//  Copyright (c) 2013年 MUU KOJIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IP @"192.168.11.9"
#define PATH @"http://172.30.254.1"
#import <Foundation/Foundation.h>

//@protocol DetViewControllerDelegate;
@interface DetViewController : UIViewController{
    int spot_id3;
}
@property int spot_id3;
@property (weak, nonatomic) IBOutlet UIImageView *pic2;
@property (strong, nonatomic)NSString *spot_id;
@property (weak,nonatomic) NSString* image_url;
@property (strong, nonatomic) IBOutlet UILabel *chiar;
@property (strong, nonatomic) IBOutlet UILabel *name;

//@property (nonatomic, assign) id<DetViewControllerDelegate> delegate2;
- (void)Getimage:(NSString*) path;
- (void)GetPhoto:(int) spot_id;

@end
//@protocol DetViewControllerDelegate
//@property (nonatomic, retain) NSString *spot_id;
//@end