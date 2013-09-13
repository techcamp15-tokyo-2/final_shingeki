//
//  HTTP.h
//  ISU
//
//  Created by admin on 2013/09/11.
//  Copyright (c) 2013年 MUU KOJIMA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTTP : NSObject

//+ (void) PostImage:(UIImage*)image;
+ (void) PostImage:(UIImage*)image spot_id:(int)spot_id detail:(NSString*)detail comment:(NSString*)comment lati:(float)lati langi:(float)langi;
+ (void) PostSpot:(NSString*)detail comment:(NSString*)comment lati:(float)lati langi:(float)langi;
+ (NSData*) GetSpot;

@end
