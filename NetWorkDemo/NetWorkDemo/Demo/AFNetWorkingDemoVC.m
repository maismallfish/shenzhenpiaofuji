//
//  AFNetWorkingDemoVC.m
//  NetWorkDemo
//
//  Created by wuyine on 2017/11/2.
//  Copyright © 2017年 wuyine. All rights reserved.
//
#import "AFNetWorkingDemoVC.h"
#import "AFNetWorkingDemoDataSource.h"

#import "AFURLSessionManager.h"

@interface AFNetWorkingDemoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) AFNetWorkingDemoDataSource *dataSource;
@end

@implementation AFNetWorkingDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [AFNetWorkingDemoDataSource dataSourceInitWithSRResponseNetDeleagte:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)get:(id)sender {
    NSDictionary *parameter = @{@"type":@"top",
                                @"key":@"3a7bda4e7369437ce9450026789a29c3"};
    [self.dataSource getWithUrl:@"http://v.juhe.cn/toutiao/index" interfaceIndentifier:@"" params:parameter successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)post:(id)sender {
    NSDictionary *parameter = @{@"type":@"top",
                                @"key":@"3a7bda4e7369437ce9450026789a29c3"};
    [self.dataSource postWithUrl:@"http://v.juhe.cn/toutiao/index" interfaceIndentifier:@"" params:parameter successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)upload:(id)sender {
    UIActionSheet *actionSheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择", @"立即拍照上传", nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

- (IBAction)download:(id)sender {
//    // 快捷方式获得session对象
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURL *url = [NSURL URLWithString:@"http://www.daka.com/login?username=daka&pwd=123"];
//    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
//    NSURLSessionTask *task = [session dataTaskWithURL:url
//                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
//                                    }];
//
//    // 启动任务
//    [task resume];
    
    // step1. 初始化AFURLSessionManager对象
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // step2. 获取AFURLSessionManager的task对象
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Get Net data success!");
        }
    }];
    
    // step3. 发动task
    [dataTask resume];
}

#pragma mark -- UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    [self updateImageToServer:imageData];
}

/*upload images*/
- (void)updateImageToServer:(NSData *)data
{
    NSMutableDictionary *Exparams = [[NSMutableDictionary alloc]init];
    [Exparams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:data,@"imageName", nil]];
    
    [self.dataSource uploadImageWithData:data url:@"http://v.juhe.cn/toutiao/avatar" indentifier:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (buttonIndex == 0) { //相册
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }else if (buttonIndex == 1){  //照相机
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }else{
        if (buttonIndex == 0) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}
@end
