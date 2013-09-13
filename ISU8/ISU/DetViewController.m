//
//  DetViewController.m
//  ISU
//
//  Created by admin on 2013/09/12.
//  Copyright (c) 2013年 MUU KOJIMA. All rights reserved.
//

#import "DetViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#define IP @"192.168.11.9"
#define IP2 @"172.30.254.1"
#import "ViewController.h"

@interface DetViewController ()

@end

@implementation DetViewController
@synthesize spot_id3;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        // 初期処理
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //上部ツールバー作成 NavigationBarと同じ44ピクセルで作成
    UIToolbar * toolBarA = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:toolBarA];
    
    UIBarButtonItem * button1 = [[UIBarButtonItem alloc] initWithTitle:@"ホーム" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
    
    //伸び縮みするスペーサ
    UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //固定幅のスペーサ
    UIBarButtonItem * fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -5;//負の値を指定すると間隔が詰まります
    
    //toolBarに作成したボタンを設置します
    toolBarA.items = [NSArray arrayWithObjects:button1, flexibleSpace, nil];
    [self GetPhoto:spot_id3];

    
//    NSString *image_path = [PATH stringByAppendingString:self.image_url];
//    [self Getimage:image_path];
}

//メイン画面に戻る
- ( void )home//:( id )inSender
{
    //ビューコントローラーを一つ戻る
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"hello1");
    return;
}

//[self dismissViewControllerAnimated:YES completion:nil];

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Getimage:(NSString*) path{
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage* image = [[UIImage alloc] initWithData:data];
    self.pic2.image = image;
    NSLog(@"success");
    [SVProgressHUD dismiss];
}

- (void)GetPhoto:(int) spot_id{
    [SVProgressHUD showWithStatus:@"通信中" maskType:SVProgressHUDMaskTypeBlack];

    static AFHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:PATH]]];
    });
    NSString *path = [NSString stringWithFormat:@"api/photo/%d.json", spot_id3];
//    NSString *path = (@"api/photo/1.json");
    
    [_sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[_sharedClient requestWithMethod:@"GET" path:path parameters:nil] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON: %@", JSON);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:JSON];
        self.image_url = [dic objectForKey:@"image_url"];
        NSString *image_path = [PATH stringByAppendingString:self.image_url];
        NSDictionary *photodic = [NSDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithDictionary:[dic objectForKey:@"photo"]]];
        [self Getimage:image_path];
        self.chiar.text = [photodic objectForKey:@"title"];
        self.name.text = [photodic objectForKey:@"phrase"];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
        
    }];
    [_sharedClient enqueueHTTPRequestOperation:operation];
    

}
@end
