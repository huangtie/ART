//
//  ARTMemberEditViewController.m
//  ART
//
//  Created by huangtie on 16/6/23.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTMemberEditViewController.h"
#import "ARTMemberEditCell.h"
#import "ARTRequestUtil.h"
#import "ARTAssetsViewController.h"
#import "ARTRequestUtil.h"
#import "ARTMemberInputViewController.h"
#import <ActionSheetPicker.h>
#import "ARTPickerView.h"

@interface ARTMemberEditViewController()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray *cell2D;
@property (nonatomic , strong) NSArray *cityDatas;

@property (nonatomic , strong) ARTMemberEditCell *faceCell;
@property (nonatomic , strong) ARTMemberEditCell *nickCell;
@property (nonatomic , strong) ARTMemberEditCell *phoneCell;
@property (nonatomic , strong) ARTMemberEditCell *emailCell;
@property (nonatomic , strong) ARTMemberEditCell *shengCell;
@property (nonatomic , strong) ARTMemberEditCell *shiCell;
@property (nonatomic , strong) ARTMemberEditCell *quCell;
@property (nonatomic , strong) ARTMemberEditCell *signCell;

@property (nonatomic , strong) ARTUpsetParam *param;
@property (nonatomic , strong) ARTCityParam *cityParam;
@end

@implementation ARTMemberEditViewController

+ (ARTMemberEditViewController *)launchViewController:(UIViewController *)viewController
{
    ARTMemberEditViewController *editVC = [[ARTMemberEditViewController alloc] init];
    [viewController.navigationController pushViewController:editVC animated:YES];
    return editVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"基本资料";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = UICOLOR_ARGB(0xfffafafa);
    self.tableView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    self.tableView.separatorColor = UICOLOR_ARGB(0xffe5e5e5);
    [self.view addSubview:self.tableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保存修改" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
    button.titleLabel.font = FONT_WITH_17;
    [button addTarget:self action:@selector(_rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    [self updateSubviews];
}

- (void)dealloc
{
    
}

- (BOOL)isChange
{
    BOOL change = NO;
    ARTUserInfo *info = [ARTUserManager sharedInstance].userinfo.userInfo;
    
    if (![self.param.userNick isEqualToString:info.userNick]
        || ![self.param.userPhone isEqualToString:info.userPhone]
        || ![self.param.userEmail isEqualToString:info.userEmail]
        || ![self.param.userSign isEqualToString:info.userSign]
        || ![self.param.userSheng isEqualToString:info.userCity.codeSheng]
        || ![self.param.userShi isEqualToString:info.userCity.codeShi]
        || ![self.param.userQu isEqualToString:info.userCity.codeQu])
    {
        change = YES;
    }
    return change;
}

#pragma mark LAYOUT
- (void)updateSubviews
{
    ARTUserInfo *info = [ARTUserManager sharedInstance].userinfo.userInfo;
    
    //头像
    [self.faceCell.faceView sd_setImageWithURL:[NSURL URLWithString:info.userImage]];
    
    //昵称
    self.nickCell.contenLabel.text = self.param.userNick;
    
    //手机号
    self.phoneCell.contenLabel.text = self.param.userPhone;
    
    //邮箱
    self.emailCell.contenLabel.text = self.param.userEmail;
    
    //省
    self.shengCell.contenLabel.text = self.param.shengName;
    
    //市
    self.shiCell.contenLabel.text = self.param.shiName;
    
    //区
    self.quCell.contenLabel.text = self.param.quName;
    
    //签名
    self.signCell.contenLabel.text = self.param.userSign;
}

#pragma mark GET_SET
- (ARTCityParam *)cityParam
{
    if (!_cityParam)
    {
        _cityParam = [[ARTCityParam alloc] init];
    }
    return _cityParam;
}

- (ARTUpsetParam *)param
{
    if (!_param)
    {
        ARTUserInfo *info = [ARTUserManager sharedInstance].userinfo.userInfo;
        
        _param = [[ARTUpsetParam alloc] init];
        _param.userNick = info.userNick;
        _param.userPhone = info.userPhone;
        _param.userEmail = info.userEmail;
        _param.userSheng = info.userCity.codeSheng;
        _param.userShi = info.userCity.codeShi;
        _param.userQu = info.userCity.codeQu;
        _param.userSign = info.userSign;
        
        _param.shengName = info.userCity.nameSheng;
        _param.shiName = info.userCity.nameShi;
        _param.quName = info.userCity.nameQu;
    }
    return _param;
}

- (NSArray *)cell2D
{
    if (!_cell2D)
    {
        _cell2D = @[@[self.faceCell,self.nickCell,self.phoneCell,self.emailCell],@[self.shengCell,self.shiCell,self.quCell],@[self.signCell]];
    }
    return _cell2D;
}

#define CELL_HEIGHT 60
- (ARTMemberEditCell *)faceCell
{
    if (!_faceCell)
    {
        _faceCell = [[ARTMemberEditCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _faceCell.faceView.hidden = NO;
        _faceCell.contenLabel.hidden = YES;
        _faceCell.textLabel.text = @"头像";
    }
    return _faceCell;
}

- (ARTMemberEditCell *)nickCell
{
    if (!_nickCell)
    {
        _nickCell = [[ARTMemberEditCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CELL_HEIGHT)];
        _nickCell.textLabel.text = @"昵称";
    }
    return _nickCell;
}

- (ARTMemberEditCell *)phoneCell
{
    if (!_phoneCell)
    {
        _phoneCell = [[ARTMemberEditCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CELL_HEIGHT)];
        _phoneCell.textLabel.text = @"手机号";
    }
    return _phoneCell;
}

- (ARTMemberEditCell *)emailCell
{
    if (!_emailCell)
    {
        _emailCell = [[ARTMemberEditCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CELL_HEIGHT)];
        _emailCell.textLabel.text = @"邮箱";
    }
    return _emailCell;
}

- (ARTMemberEditCell *)shengCell
{
    if (!_shengCell)
    {
        _shengCell = [[ARTMemberEditCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CELL_HEIGHT)];
        _shengCell.textLabel.text = @"地区(省)";
    }
    return _shengCell;
}

- (ARTMemberEditCell *)shiCell
{
    if (!_shiCell)
    {
        _shiCell = [[ARTMemberEditCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CELL_HEIGHT)];
        _shiCell.textLabel.text = @"地区(市)";
    }
    return _shiCell;
}

- (ARTMemberEditCell *)quCell
{
    if (!_quCell)
    {
        _quCell = [[ARTMemberEditCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CELL_HEIGHT)];
        _quCell.textLabel.text = @"地区(区或县)";
    }
    return _quCell;
}

- (ARTMemberEditCell *)signCell
{
    if (!_signCell)
    {
        _signCell = [[ARTMemberEditCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CELL_HEIGHT)];
        _signCell.textLabel.text = @"个性签名";
    }
    return _signCell;
}

#pragma mark ACTION
- (void)_backItemClicked:(id)sender
{
    if ([self isChange])
    {
        WS(weak)
        [ARTAlertView alertTitle:@"温馨提示" message:@"您有信息已编辑但尚未提交保存,是否提交?" doneTitle:@"提交修改" cancelTitle:@"直接退出" doneBlock:^{
            [weak requestUpset];
        } cancelBlock:^{
            [weak.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    
    [super _backItemClicked:sender];
}

- (void)_rightItemClicked:(id)sender
{
    [self requestUpset];
}

#pragma mark REQUEST
- (void)requestUpLoadFace:(UIImage *)image
{
    [self displayHUD];
    WS(weak)
    [ARTRequestUtil requestUploadFace:image completion:^(NSURLSessionDataTask *task, NSString *userImage) {
        [weak hideHUD];
        [weak.view displayTostSuccess:@"头像上传成功"];
        [weak.faceCell.faceView sd_setImageWithURL:[NSURL URLWithString:userImage]];
        [ARTUserManager sharedInstance].userinfo.userInfo.userImage = userImage;
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
    }];
}

- (void)requestUpset
{
    if (!self.param.userSheng.length || !self.param.userShi.length || !self.param.userQu.length)
    {
        [self.view displayTostError:@"请选择完整的省/市/区"];
        return;
    }
    
    [self displayHUD];
    WS(weak)
    [ARTRequestUtil requestUpdateInfo:self.param completion:^(NSURLSessionDataTask *task) {
        [weak hideHUD];
        [weak.view displayTostSuccess:@"修改成功"];
        [weak requestUserInfo];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
    }];
}

- (void)requestUserInfo
{
    [ARTRequestUtil requestUserinfo:[ARTUserManager sharedInstance].userinfo.userInfo.userID completion:^(NSURLSessionDataTask *task, ARTUserInfo *data) {
        [ARTUserManager sharedInstance].userinfo.userInfo = data;
    } failure:^(ErrorItemd *error) {
        
    }];
}

- (void)requestCityList:(void (^)())completion
{
    WS(weak)
    [ARTRequestUtil requestCityList:self.cityParam completion:^(NSURLSessionDataTask *task, NSArray<ARTCityData *> *datas) {
        weak.cityDatas = datas;
        completion();
    } failure:^(ErrorItemd *error) {
        
    }];
}

#pragma mark DELEGATE_TEBLE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cell2D.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.cell2D[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cell2D[indexPath.section][indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARTMemberEditCell *cell = self.cell2D[indexPath.section][indexPath.row];
    return cell.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WS(weak)
    ARTMemberEditCell *cell = self.cell2D[indexPath.section][indexPath.row];
    if (cell == self.faceCell)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"拍一张", nil];
        [sheet showInView:self.view];
    }
    else if (cell == self.nickCell)
    {
        [ARTMemberInputViewController launchViewController:self title:@"昵称" text:self.param.userNick inputBlock:^(NSString *text) {
            weak.param.userNick = text;
            weak.nickCell.contenLabel.text = text;
        }];
    }
    else if (cell == self.phoneCell)
    {
        [ARTMemberInputViewController launchViewController:self title:@"手机号" text:self.param.userPhone inputBlock:^(NSString *text) {
            weak.param.userPhone = text;
            weak.phoneCell.contenLabel.text = text;
        }];
    }
    else if (cell == self.emailCell)
    {
        [ARTMemberInputViewController launchViewController:self title:@"邮箱" text:self.param.userEmail inputBlock:^(NSString *text) {
            weak.param.userEmail = text;
            weak.emailCell.contenLabel.text = text;
        }];
    }
    else if (cell == self.signCell)
    {
        [ARTMemberInputViewController launchViewController:self title:@"个性签名" text:self.param.userSign inputBlock:^(NSString *text) {
            weak.param.userSign = text;
            weak.signCell.contenLabel.text = text;
        }];
    }
    else if (cell == self.shengCell)
    {
        self.cityParam.type = @"0";
        WS(weak)
        [self requestCityList:^{
            [ARTPickerView showInView:weak.view data:[weak CityStrings] doneBlock:^(NSInteger index) {
                if (index < weak.cityDatas.count)
                {
                    ARTCityData *data = weak.cityDatas[index];
                    weak.param.userSheng = data.code;
                    weak.param.shengName = data.name;
                    weak.shengCell.contenLabel.text = data.name;
                    weak.param.userShi = @"";
                    weak.param.userQu = @"";
                    weak.shiCell.contenLabel.text = @"";
                    weak.quCell.contenLabel.text = @"";
                }
            }];
        }];
    }
    else if (cell == self.shiCell)
    {
        if (!self.param.userSheng.length)
        {
            [self.view displayTostError:@"请先选择省"];
            return;
        }
        
        self.cityParam.type = @"1";
        self.cityParam.code = self.param.userSheng;
        WS(weak)
        [self requestCityList:^{
            [ARTPickerView showInView:weak.view data:[weak CityStrings] doneBlock:^(NSInteger index) {
                if (index < weak.cityDatas.count)
                {
                    ARTCityData *data = weak.cityDatas[index];
                    weak.param.userShi = data.code;
                    weak.param.shiName = data.name;
                    weak.shiCell.contenLabel.text = data.name;
                    weak.param.userQu = @"";
                    weak.quCell.contenLabel.text = @"";
                }
            }];
        }];
    }
    else if (cell == self.quCell)
    {
        if (!self.param.userShi.length)
        {
            [self.view displayTostError:@"请先选择市"];
            return;
        }
        
        self.cityParam.type = @"2";
        self.cityParam.code = self.param.userShi;
        WS(weak)
        [self requestCityList:^{
            [ARTPickerView showInView:weak.view data:[weak CityStrings] doneBlock:^(NSInteger index) {
                if (index < weak.cityDatas.count)
                {
                    ARTCityData *data = weak.cityDatas[index];
                    weak.param.userQu = data.code;
                    weak.param.quName = data.name;
                    weak.quCell.contenLabel.text = data.name;
                }
            }];
        }];
    }
}

- (NSArray *)CityStrings
{
    NSMutableArray *strings = [NSMutableArray array];
    for (ARTCityData *data in self.cityDatas)
    {
        [strings addObject:data.name];
    }
    return strings;
}

#pragma mark DELEGATE_ACTIONSHEET
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        ARTAssetsViewController *assetVC = [[ARTAssetsViewController alloc] init];
        assetVC.assetStyle = ARTASSET_STYLE_SINGLE;
        assetVC.multipleMax = 1;
        assetVC.chooseBlock = ^(NSArray *assets)
        {
            if (assets.count)
            {
                ALAsset *asset = assets.firstObject;
                CGImageRef thumbnailImageRef = [asset thumbnail];
                UIImage *image = [UIImage imageWithCGImage:thumbnailImageRef];
                [self requestUpLoadFace:image];
            }
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:assetVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if(buttonIndex == 1)
    {
        
    }
}





















@end
