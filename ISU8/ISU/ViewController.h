//
//  ViewController.h
//  ISU
//
//  Created by MUU KOJIMA on 9/5/13.
//  Copyright (c) 2013 MUU KOJIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Post2ViewController.h"
#import "DetViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Foundation/Foundation.h>
#define IP @"192.168.11.9"
#define IP2 @"172.30.254.1"
#define PATH @"http://172.30.254.1:3000" 


@interface ViewController : UIViewController <CLLocationManagerDelegate,GMSMapViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, Post2ViewControllerDelegate> {
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinate;
    Post2ViewController *pvc;
    DetViewController *pvc2;
    int count;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *spot_id;
@property (strong, nonatomic) CLLocation * location;

- (void)setCoordinate:(CLLocationCoordinate2D)_coordinate title:(NSString*)title snip:(NSString*)snip id:(int)spot_id;
- (void) Getspot:(float)lati langi:(float)langi;

@end
