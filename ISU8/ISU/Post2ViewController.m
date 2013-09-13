//
//  Post2ViewController.m
//  ISU
//
//  Created by MUU KOJIMA on 9/9/13.
//  Copyright (c) 2013 MUU KOJIMA. All rights reserved.
//

#import "Post2ViewController.h"
#import "ViewController.h"
#import "HTTP.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"


@interface Post2ViewController ()

@end

@implementation Post2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //オブジェクトを調べる
    //NSLog(@"pic %@", _pic);
    
    //いったんUImageViewに表示するために、空にする
    _pic.image = _image;
    
    //上部ツールバー作成 NavigationBarと同じ44ピクセルで作成
    UIToolbar * toolBarA = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:toolBarA];
    
    UIBarButtonItem * button1 = [[UIBarButtonItem alloc] initWithTitle:@"ホーム" style:UIBarButtonItemStyleBordered target:self action:@selector(action1)];
    
    //伸び縮みするスペーサ
    UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //固定幅のスペーサ
    UIBarButtonItem * fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -5;//負の値を指定すると間隔が詰まります
    
    //toolBarに作成したボタンを設置します
    toolBarA.items = [NSArray arrayWithObjects:button1, flexibleSpace, nil];
    
    // キーボードの改行ボタンを完了ボタンにする
    _phrase.returnKeyType = UIReturnKeyDone;
    // delegate
    _phrase.delegate = self;
    
    // キーボードの改行ボタンを完了ボタンにする
    _comment.returnKeyType = UIReturnKeyDone;
    // delegate
    _comment.delegate = self;
    

    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // キーボードを隠す
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)post:(id)sender {
    
    
    
    if([_phrase.text isEqualToString:@""]){
        _phrase.placeholder = @"何も入力されてません";
    }else if([_comment.text isEqualToString:@""]){
        _comment.placeholder = @"何も入力されていません";
        }else{
    [self dismissViewControllerAnimated:YES completion:nil];
//    緯度•経度をログに表示
//    NSLog(@"didUpdateToLocation latitude=%f, longitude=%f",
//          [self.location coordinate].latitude,
//          [self.location coordinate].longitude);
    
    //テキストフィールドの文字をストリングに代入
    NSString *comment = _comment.text;
    NSString *phrase = _phrase.text;
    
    //テキストフィールドの文字をコンソールに表示
    NSLog(@"%@ %@",comment, phrase);
    
    float lati = ((CLLocationCoordinate2D)[self.location coordinate]).latitude;
    float langi = ((CLLocationCoordinate2D)[self.location coordinate]).longitude;

    //NSData *JSONresponse = [HTTP PostSpot:phrase comment:comment lati:lati langi:langi];
//    [HTTP PostSpot:phrase comment:comment lati:lati langi:langi];
    //NSLog(JSONresponse);
//    [HTTP PostImage:self.pic.image spot_id:1];
    [self PostImage:self.pic.image title:phrase comment:comment lati:lati langi:langi];
    

    
    //ピンの緯度•経度に代入
//    [_delegate setCoordinate:coordinate title:@"hoge" snip:@"hoge"];
    }
}




- ( void )action1//:( id )inSender
{
    // ボタンを押された時の処理をここに追加
    
    
    //ビューコントローラーを一つ戻る
    [self dismissViewControllerAnimated:YES completion:nil];
    //緯度・経度を出力
    
    NSLog(@"hello1");
    return;
}


- (void) PostImage:(UIImage*)image title:(NSString*)title comment:(NSString*)comment lati:(float)lati langi:(float)langi{
     [SVProgressHUD showWithStatus:@"通信中" maskType:SVProgressHUDMaskTypeBlack];
    
     NSData *imagedata = UIImageJPEGRepresentation(image, 0.9);
//    NSData *imagedata = [[NSData alloc] initWithData:UIImagePNGRepresentation(image, 0.9)];
    static AFHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:PATH]]];
    });
    
    //    NSDictionary *userDic = @{@"photo[travel_id]": self.travel_id};
    NSString *path = @"api/photo.json";
    NSDictionary *photoDic = @{@"photo[lati]":@(lati),@"photo[longi]":@(langi),@"photo[title]":title,@"photo[phrase]":comment};
    
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
                                             NSDictionary *photoDic =[NSDictionary dictionaryWithDictionary:[dic objectForKey:@"photo"]];
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
                                             float latitude = [[photoDic objectForKey:@"lati"] floatValue];
                                             float longitude = [[photoDic objectForKey:@"longi"] floatValue];
                                             CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                                             
                                             NSString* title = [photoDic objectForKey:@"title"];
                                             NSString* detail = [photoDic objectForKey:@"phrase"];
                                             int spot_id = [[photoDic objectForKey:@"id"] intValue];

                                             [_delegate setCoordinate:coordinate title:title snip:detail id:spot_id];
                                             
                                             
                                             //                                             WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:@"画像のUploadに成功しました"];
                                             //                                             [notice show];
                                             [SVProgressHUD dismiss];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"Error: %@", error);
                                             
                                             
                                             //                                             WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Network Error" message:@"Check your network connection."];
                                             //                                             [notice show];
                                             
                                             
                                             
                                         }];
    [_sharedClient enqueueHTTPRequestOperation:operation];
    
}



@end
