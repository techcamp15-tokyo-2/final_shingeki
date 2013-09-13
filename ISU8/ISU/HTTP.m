//
//  HTTP.m
//  ISU
//
//  Created by admin on 2013/09/11.
//  Copyright (c) 2013年 MUU KOJIMA. All rights reserved.
//

#import "HTTP.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"


@implementation HTTP

+ (void) PostImage:(UIImage*)image spot_id:(int)spot_id detail:(NSString*)detail comment:(NSString*)comment lati:(float)lati langi:(float)langi{
    NSData *imagedata = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
    static AFHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://172.30.254.1:3000"]]];
    });
    
    //    NSDictionary *userDic = @{@"photo[travel_id]": self.travel_id};
    NSString *path = @"api/photo";
 NSDictionary *photoDic = @{@"photo[lati]":@"100",@"photo[longi]":@"100",@"photo[title]":@"hoge",@"photo[phrase]":@"hoge"};
    
    [_sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         
                                         JSONRequestOperationWithRequest:[_sharedClient multipartFormRequestWithMethod:@"POST"
                                                                                                                  path: path
                                                                                                            parameters: photoDic
                                                                                             constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                                                                 [formData appendPartWithFileData:imagedata name:@"photo[image]" fileName:[NSString stringWithFormat:@"image_%lf.png",[[[NSDate alloc] init] timeIntervalSince1970]] mimeType:@"image/jpeg"];
                                                                                                 
                                                                                             }]
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             NSLog(@"JSON: %@", JSON);
                                             
                                             NSDictionary *dic = [NSDictionary dictionaryWithDictionary:JSON];
//                                             NSString* jsonString = (NSString*)JSON;
                                             //NSString* jsonString =  JSON;//(NSString *)[JSON object];
                                             //NSLog(@"String: %@", jsonString);
                                             
                                             //NSLog(@"json class %@", [jsonString class]);
//                                             NSData* jsonData = [NSKeyedArchiver archivedDataWithRootObject:JSON];
                                             //NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                             //NSLog(@"Data: %@", jsonData);
                                             //NSError *error;
                                             //NSDictionary *array = JSON;
                                             /*[NSJSONSerialization JSONObjectWithData:jsonData
                                                                                              options:NSJSONReadingAllowFragments
                                                                                                error:&error];*/
                                             NSLog(@"dic: %@", dic);
                                             
                                             for (NSString *key in [dic allKeys]) {
                                                 NSLog(@"key:%@ , value:%@", key, [dic objectForKey:key]);
                                             }
                                             
                                             //                                             WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:@"画像のUploadに成功しました"];
                                             //                                             [notice show];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"Error: %@", error);
                                             
                                             
                                             //                                             WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Network Error" message:@"Check your network connection."];
                                             //                                             [notice show];
                                             
                                             
                                             
                                         }];
    [_sharedClient enqueueHTTPRequestOperation:operation];
    
}


+ (void) PostSpot:(NSString *)detail comment:(NSString *)comment lati:(float)lati langi:(float)langi{
    // 送信するリクエストを生成する。
    __block NSData *responseJSON = [[NSData alloc]init];
    NSURL *url = [NSURL URLWithString:@"http://172.30.255.218:3000/spot.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *reqBody = [NSString stringWithFormat: @"utf8=✓g&spot[detail]=hoge&spot[title]=hoge&spot[longi]=100&spot[lati]=100"];
    NSLog(@"reqBody: %@", reqBody);
    
    [request setHTTPBody:[reqBody dataUsingEncoding:NSUTF8StringEncoding]];
    // リクエストを送信する。
    // 第３引数のブロックに実行結果が渡される。
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            // エラー処理を行う。
            if (error.code == -1003) {
                NSLog(@"not found hostname. targetURL=%@", url);
            } else if (-1019) {
                NSLog(@"auth error. reason=%@", error);
            } else {
                NSLog(@"unknown error occurred. reason = %@", error);
            }
            
        } else {
            int httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (httpStatusCode == 404) {
                NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url);
                // } else if (・・・) {
                // 他にも処理したいHTTPステータスがあれば書く。
                
            } else {
                NSLog(@"success request!!");
                NSLog(@"statusCode = %d", ((NSHTTPURLResponse *)response).statusCode);
                NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                responseJSON = data;
                // ここはサブスレッドなので、メインスレッドで何かしたい場合には
                dispatch_async(dispatch_get_main_queue(), ^{
                    // ここに何か処理を書く。
//                     response = data;
                });
            }
        }
    }];
    //return responseJSON;

}

+ (NSData*) GetSpot{
    __block NSData *responseJSON = [[NSData alloc]init];
    // 送信するリクエストを生成する。
    NSURL *url = [NSURL URLWithString:@"http://172.30.255.218:3000/spot.json"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    
    // リクエストを送信する。
    // 第３引数のブロックに実行結果が渡される。
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            // エラー処理を行う。
            if (error.code == -1003) {
                NSLog(@"not found hostname. targetURL=%@", url);
            } else if (-1019) {
                NSLog(@"auth error. reason=%@", error);
            } else {
                NSLog(@"unknown error occurred. reason = %@", error);
            }
            
        } else {
            int httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (httpStatusCode == 404) {
                NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url);
                // } else if (・・・) {
                // 他にも処理したいHTTPステータスがあれば書く。
                
            } else {
                NSLog(@"success request!!");
                NSLog(@"statusCode = %d", ((NSHTTPURLResponse *)response).statusCode);
                NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                 responseJSON = data;
                // ここはサブスレッドなので、メインスレッドで何かしたい場合には
                dispatch_async(dispatch_get_main_queue(), ^{
                    // ここに何か処理を書く。
                });
            }
        }
    }];
    
       return responseJSON;
}


@end
