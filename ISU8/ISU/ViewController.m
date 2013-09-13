//
//  ViewController.m
//  ISU
//
//  Created by MUU KOJIMA on 9/5/13.
//  Copyright (c) 2013 MUU KOJIMA. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController {
    GMSMapView *mapView_;
}

@synthesize locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    count = 0;
    locationManager = [[CLLocationManager alloc] init];
    
    // 位置情報サービスが利用できるかどうかをチェック
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager.delegate = self; // ……【1】
        // 測位開始
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services not available.");
    }
    
    [self Getspot:10 langi:10];
    
}

- (void)initialLoad
{
    // Do any additional setup after loading the view, typically from a nib.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:16];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    //自分の位置ボタン
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    self.view = mapView_;
    // Creates a marker in the center of the map.
    /*GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.title = @"You are here!";
    marker.snippet = @"Location";
    marker.map = mapView_;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];*/
    
    
    //上部ツールバー作成 NavigationBarと同じ44ピクセルで作成
    UIToolbar * toolBarA = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:toolBarA];

//    UIBarButtonItem * button1 = [[UIBarButtonItem alloc] initWithTitle:@"ボタン1" style:UIBarButtonItemStyleBordered target:self action:@selector(action1)];
    UIBarButtonItem * button2 = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStyleBordered target:self action:@selector(action2:)];
    UIBarButtonItem * button3 = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(action3:)];
    
    //伸び縮みするスペーサ
    UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //固定幅のスペーサ
    UIBarButtonItem * fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -5;//負の値を指定すると間隔が詰まります
    
    //toolBarに作成したボタンを設置します
    toolBarA.items = [NSArray arrayWithObjects:button2, fixedSpace, button3, nil];
    
}


// 位置情報更新時
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
//    //緯度・経度を出力
//    NSLog(@"didUpdateToLocation latitude=%f, longitude=%f",
//          [newLocation coordinate].latitude,
//          [newLocation coordinate].longitude);
    
    self.location = [[CLLocation alloc] init];
    self.location = newLocation;
    
    coordinate = [newLocation coordinate];
    
    if (count==0) {
        count++;
        [self initialLoad];
    }
}

//カメラ
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


//カメラを起動
- (void)kickCamera
{
    UIImagePickerController *imagePickerController =[[UIImagePickerController alloc] init];
    
    //カメラ機能を選択
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePickerController.delegate = self;
    
    //YESにしないと、UIImage(カメラで撮ったデータ) が取得できない
    imagePickerController.allowsEditing = YES;
    
    //モーダルビューでカメラ起動
    [self presentViewController:imagePickerController animated:YES completion:nil];
}



// 測位失敗時や、5位置情報の利用をユーザーが「不許可」とした場合などに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- ( void )action1//:( id )inSender
//{
//    // ボタンを押された時の処理をここに追加
//    //カメラを起動
//    //[self kickCamera];
//    NSLog(@"hello1");
//    return;
//}

- ( void )action2:( id )inSender
{
    NSLog(@"hello2");
    // ボタンを押された時の処理をここに追加
    [self Getspot:10 langi:10];
    return;
}

- ( void )action3:( id )inSender
{
    //カメラを起動
    [self kickCamera];
    NSLog(@"hello3");
    // ボタンを押された時の処理をここに追加
    return;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //戻る
    [self dismissViewControllerAnimated:NO completion:nil];
   //次の遷移を生成
    pvc = [[Post2ViewController alloc] initWithNibName:@"Post2ViewController" bundle:nil];
    
    pvc.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    pvc.location = self.location;
    pvc.delegate = self;
    
    //遷移
    [self presentViewController:pvc animated:YES completion:nil];
    NSLog(@"Hello");
}


- (void)setCoordinate:(CLLocationCoordinate2D)_coordinate title:(NSString*)title snip:(NSString*)snip id:(int)spot_id
{
    coordinate = _coordinate;
    
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.title = title;
    marker.snippet = snip;
    marker.map = mapView_;
    marker.userData = @(spot_id);
    marker.icon = [UIImage imageNamed:@"pin.png"];
//    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    
}

- (void) Getspot:(float)lati langi:(float)langi{
    [SVProgressHUD showWithStatus:@"通信中" maskType:SVProgressHUDMaskTypeBlack];
    static AFHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:PATH]]];
    });
    
    //    NSDictionary *userDic = @{@"photo[travel_id]": self.travel_id};
    NSString *path = @"api/photo";
    NSDictionary *spotDic = @{@"photo[lati]":[NSNumber numberWithFloat:lati],@"photo[longi]":[NSNumber numberWithFloat:langi]};
    
    [_sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[_sharedClient requestWithMethod:@"GET" path:path parameters:spotDic] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        NSArray *array = [NSArray arrayWithArray:JSON];
            for(NSDictionary *dic in array){
                 NSDictionary *photoDic =[NSDictionary dictionaryWithDictionary:[dic objectForKey:@"photo"]];
    //                [mapView_ clear];

            float latitude = [[photoDic objectForKey:@"lati"] floatValue];
            float longitude = [[photoDic objectForKey:@"longi"] floatValue];
            CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(latitude, longitude);
            
            NSString* title = [photoDic objectForKey:@"title"];
            NSString* detail = [photoDic objectForKey:@"phrase"];
                int spot_id = [[photoDic objectForKey:@"id"] intValue];
                [self setCoordinate:coordinate2 title:title snip:detail id:spot_id];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:nil];

    [_sharedClient enqueueHTTPRequestOperation:operation];
    
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    //次の遷移を生成
    pvc2 = [[DetViewController alloc] initWithNibName:@"DetViewController" bundle:nil];
    pvc2.spot_id3 = [marker.userData intValue];
    
    //遷移
    [self presentViewController:pvc2 animated:YES completion:nil];
    
    
    
    NSLog(@"YES");
}


@end