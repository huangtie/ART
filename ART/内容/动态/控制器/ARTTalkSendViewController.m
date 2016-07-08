//
//  ARTTalkSendViewController.m
//  ART
//
//  Created by huangtie on 16/6/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkSendViewController.h"
#import "ARTTalkTextView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ARTAssetsViewController.h"
#import "ARTPreviewViewController.h"
#import "ARTRequestUtil.h"

@interface ARTTalkSendViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic , strong) ARTTalkTextView *textView;
@property (nonatomic , strong) UIView *inputRectView;

@property (nonatomic , strong) UIView *screenView;
@property (nonatomic , strong) UIButton *allButton;
@property (nonatomic , strong) UIButton *friendButton;

@property (nonatomic , strong) UIView *imageRectView;
@property (nonatomic , strong) NSMutableArray <ALAsset *> *uploadImages;
@property (nonatomic , strong) ALAssetsLibrary *assetsLibrary;
@end

@implementation ARTTalkSendViewController

#define IMAGE_WIDTH 125
#define IMAGE_UPLOAD_MAX 9
#define IMAGE_ROW_MAX 5

+ (ARTTalkSendViewController *)launchViewController:(UIViewController *)viewController
{
    ARTTalkSendViewController *vc = [[ARTTalkSendViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发状态";
    self.view.backgroundColor = COLOR_YSYC_GRAY;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"完成" forState:UIControlStateNormal];
    [sendButton setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
    sendButton.titleLabel.font = FONT_WITH_18;
    [sendButton addTarget:self action:@selector(barSendItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    self.inputRectView.top = NAVIGATION_HEIGH + 10;
    [self.view addSubview:self.inputRectView];
    [self.inputRectView addSubview:self.textView];
    self.screenView.left = 15;
    self.screenView.top = self.inputRectView.bottom + 10;
    [self.view addSubview:self.screenView];
    self.imageRectView.top = self.screenView.bottom + 10;
    self.imageRectView.left = 15;
    [self.view addSubview:self.imageRectView];
    
    self.uploadImages = [NSMutableArray array];
    [self layoutImageRect];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
}

#pragma mark LAYOUT
- (void)layoutImageRect
{
    NSMutableArray *data2D = [[NSMutableArray alloc] init];
    NSMutableArray *tmps = [[NSMutableArray alloc] init];
    NSInteger pcount = self.uploadImages.count;
    if (pcount < IMAGE_UPLOAD_MAX)
    {
        pcount += 1;
    }
    for (NSInteger i = 1; i <= pcount; i++)
    {
        if (i - 1 < self.uploadImages.count)
        {
            [tmps addObject:self.uploadImages[i - 1]];
        }
        else
        {
            [tmps addObject:[NSNull null]];
        }
        if ((i % IMAGE_ROW_MAX == 0) || i == pcount)
        {
            [data2D addObject:tmps];
            tmps = [[NSMutableArray alloc] init];
        }
    }
    
    [self.imageRectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat spacing = (self.imageRectView.width - IMAGE_ROW_MAX * IMAGE_WIDTH) / (IMAGE_ROW_MAX - 1);
    CGFloat padding = 10;
    for (NSInteger i = 0; i < data2D.count; i++)
    {
        NSArray *items = data2D[i];
        for (NSInteger j = 0; j < items.count; j++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.size = CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH);
            imageView.left = j * (IMAGE_WIDTH + padding);
            imageView.top = i * (IMAGE_WIDTH + spacing);
            [self.imageRectView addSubview:imageView];
            
            ALAsset *asset = items[j];
            if ([asset isKindOfClass:[NSNull class]])
            {
                imageView.image = [UIImage imageNamed:@"talk_icon_5"];
            }
            else
            {
                CGImageRef thumbnailImageRef = [asset thumbnail];
                imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageItemsDidClick:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
        }
    }
}

#pragma mark GET_SET
- (UIView *)inputRectView
{
    if (!_inputRectView)
    {
        _inputRectView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 310)];
        _inputRectView.backgroundColor = [UIColor whiteColor];
        [_inputRectView clipRadius:3 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfff0f0f0)];
    }
    return _inputRectView;
}

- (ARTTalkTextView *)textView
{
    if (!_textView)
    {
        _textView = [[ARTTalkTextView alloc] initWithFrame:CGRectMake(15, 15, self.inputRectView.width - 30, self.inputRectView.height - 30)];
        _textView.placeholderColor = UICOLOR_ARGB(0xff999999);
        _textView.placeholder = @"说说你此刻想法...";
        _textView.font = FONT_WITH_16;
        _textView.textColor = UICOLOR_ARGB(0xff333333);
    }
    return _textView;
}

- (UIView *)screenView
{
    if (!_screenView)
    {
        _screenView = [[UIView alloc] init];
        _screenView.size = CGSizeMake(350, 40);
        
        UILabel *label = [[UILabel alloc] init];
        label.font = FONT_WITH_16;
        label.textColor = UICOLOR_ARGB(0xff666666);
        label.text = @"谁可以看：";
        [label sizeToFit];
        label.centerY = _screenView.height / 2;
        [_screenView addSubview:label];
        
        self.allButton.left = label.right + 5;
        [_screenView addSubview:self.allButton];
        
        self.friendButton.left = self.allButton.right + 15;
        [_screenView addSubview:self.friendButton];
    }
    return _screenView;
}

- (UIButton *)allButton
{
    if (!_allButton)
    {
        _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allButton setBackgroundImage:[UIImage imageNamed:@"talk_icon_3"] forState:UIControlStateNormal];
        [_allButton setBackgroundImage:[UIImage imageNamed:@"talk_icon_4"] forState:UIControlStateSelected];
        _allButton.selected = YES;
        [_allButton addTarget:self action:@selector(allButtonTouchAction) forControlEvents:UIControlEventTouchUpInside];
        [_allButton sizeToFit];
    }
    return _allButton;
}

- (UIButton *)friendButton
{
    if (!_friendButton)
    {
        _friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_friendButton setBackgroundImage:[UIImage imageNamed:@"talk_icon_2"] forState:UIControlStateNormal];
        [_friendButton setBackgroundImage:[UIImage imageNamed:@"talk_icon_1"] forState:UIControlStateSelected];
        _friendButton.selected = NO;
        [_friendButton addTarget:self action:@selector(friendButtonTouchAction) forControlEvents:UIControlEventTouchUpInside];
        [_friendButton sizeToFit];
    }
    return _friendButton;
}

- (UIView *)imageRectView
{
    if (!_imageRectView)
    {
        _imageRectView = [[UIView alloc] init];
        _imageRectView.size = CGSizeMake(SCREEN_WIDTH - 30, 2 * IMAGE_WIDTH + 10);
    }
    return _imageRectView;
}

#pragma mark ACTION_BUTTON
- (void)barSendItemClicked
{
    if (!self.textView.text.length && !self.uploadImages.count)
    {
        [self.view displayTostError:@"文字和图片至少有一项"];
        return;
    }
    
    if (self.textView.text.length > 1000)
    {
        [self.view displayTostError:@"文字不能超过1000个字"];
        return;
    }
    [self.view endEditing:YES];
    [self requesSend];
}

- (void)allButtonTouchAction
{
    self.allButton.selected = !self.allButton.selected;
    self.friendButton.selected = !self.allButton.selected;
}

- (void)friendButtonTouchAction
{
    self.friendButton.selected = !self.friendButton.selected;
    self.allButton.selected = !self.friendButton.selected;
}

#pragma mark ACTION_GESTURE
- (void)imageItemsDidClick:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    NSInteger index = [self.imageRectView.subviews indexOfObject:tap.view];
    if (index >= self.uploadImages.count)
    {
        WS(weak)
        [ARTAlertView alertTitle:@"请选择" message:@"图片来源" doneTitle:@"本地相册" cancelTitle:@"使用相机" doneBlock:^{
            ARTAssetsViewController *vc = [[ARTAssetsViewController alloc] init];
            vc.multipleMax = IMAGE_UPLOAD_MAX - weak.uploadImages.count;
            WS(weak)
            vc.chooseBlock = ^(NSArray *assets)
            {
                [weak.uploadImages addObjectsFromArray:assets];
                [weak layoutImageRect];
            };
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [weak presentViewController:nav animated:YES completion:nil];
        } cancelBlock:^{
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"访问摄像头出错"
                                                                    message:@"您的设备似乎没有摄像头"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                [alertView show];
            }
            else
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                picker.showsCameraControls = YES;
                picker.navigationBarHidden = YES;
                picker.delegate = weak;
                [weak presentViewController:picker animated:YES completion:nil];
            }
        }];
    }
    else
    {
        ARTPreviewViewController *preview = [[ARTPreviewViewController alloc] initWithAssets:self.uploadImages index:index];
        WS(weak)
        preview.chooseBlock = ^(NSArray *assets)
        {
            weak.uploadImages = [NSMutableArray arrayWithArray:assets];
            [weak layoutImageRect];
        };
        [self.navigationController pushViewController:preview animated:YES];
    }
}

#pragma mark REQUEST
- (void)requesSend
{
    ARTSendTalkParam *param = [[ARTSendTalkParam alloc] init];
    param.talkText = self.textView.text;
    param.talkAllLook = STRING_FORMAT_ADC(@(self.allButton.selected));
    for (ALAsset *asset in self.uploadImages)
    {
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullResolutionImage] scale:[asset.defaultRepresentation scale] orientation:(UIImageOrientation)[asset.defaultRepresentation orientation]];
        UIImage *image = [fullScreenImage imageOfOrientationUp];
        [param.talkImages addObject:UIImageJPEGRepresentation(image, .5)];
    }
    [self displayHUD];
    WS(weak)
    [ARTRequestUtil requestSendTalk:param completion:^(NSURLSessionDataTask *task) {
        [weak hideHUD];
        [weak.view displayTostSuccess:@"发表成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TALK_DIDSEND object:nil];
        [weak performBlock:^{
            [weak.navigationController popViewControllerAnimated:YES];
        } afterDelay:1.5];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
    }];
}

#pragma mark DELEGATE
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    __weak typeof(self) weakSelf = self;
    [self.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock: ^(NSURL *assetURL, NSError *error) {
        
        [weakSelf.assetsLibrary assetForURL:assetURL resultBlock: ^(ALAsset *asset) {
            [weakSelf.uploadImages addObject:asset];
        }failureBlock: ^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存图片出错" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alertView show];
        }];
    }];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (ALAssetsLibrary *)assetsLibrary {
    static dispatch_once_t onceToken;
    static ALAssetsLibrary *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ALAssetsLibrary alloc] init];
    });
    
    return sharedInstance;
}






















@end
