//
//  ARTLocalCell.m
//  ART
//
//  Created by huangtie on 16/6/8.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTLocalCell.h"
#import "ARTDownLoadManager.h"

@interface ARTLocalCell()

@property (nonatomic , strong) UIView *rectView;
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , strong) UIImageView *iconView;
@property (nonatomic , strong) UIButton *deleteButton;

@property (nonatomic , strong) UIView *markView;
@property (nonatomic , strong) UILabel *pressLabel;
@property (nonatomic , strong) UILabel *statusLabel;

@property (nonatomic , strong) ARTBookLocalData *localData;

@end

@implementation ARTLocalCell

+ (NSAttributedString *)statusText:(BOOL)isLoading
{
    NSString *text;
    NSString *imageName;
    if (isLoading)
    {
        text = @"下载中...";
        imageName = @"book_icon_7";
    }
    else
    {
        text = @"已暂停";
        imageName = @"book_icon_6";
    }
    NSMutableAttributedString * attStrA = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"     %@",text]];
    [attStrA addAttribute:NSFontAttributeName value:FONT_WITH_18 range:NSMakeRange(0, attStrA.length)];
    [attStrA addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStrA.length)];
    NSTextAttachment * textAttachmentA = [[NSTextAttachment alloc] init];
    textAttachmentA.image = [UIImage imageNamed:imageName];
    textAttachmentA.bounds=CGRectMake(0, -4, 21, 21);
    NSAttributedString * imageStrA = [NSAttributedString attributedStringWithAttachment:textAttachmentA];
    [attStrA replaceCharactersInRange:NSMakeRange(0, 4) withAttributedString:imageStrA];
    return attStrA;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.rectView];
        self.deleteButton.left = self.rectView.left - self.deleteButton.width / 2;
        self.deleteButton.top = self.rectView.top - self.deleteButton.height / 2;
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (void)updateData:(ARTBookLocalData *)data isDelete:(BOOL)isDelete
{
    self.localData = data;
    
    //封面
    self.imageView.image = [UIImage imageWithContentsOfFile:FILE_PATH_PIC(data.face)];
    
    //是否已下载完成
    if ([ARTDownLoadManager isDownFinish:data])
    {
        self.markView.hidden = YES;
        self.iconView.hidden = NO;
    }
    else
    {
        self.markView.hidden = NO;
        self.iconView.hidden = YES;
    }
    
    //删除按钮
    self.deleteButton.hidden = !isDelete;
    
    //进度
    CGFloat bi = (CGFloat)data.bookFinishCount / (CGFloat)data.bookAllCount;
    self.pressLabel.text = [NSString stringWithFormat:@"%.1f%%",bi * 100];
    
    //暂停或下载中
    self.statusLabel.attributedText = [ARTLocalCell statusText:[ARTDownLoadManager isDownLoading:data.bookID]];
    

}

#pragma mark GET_SET
- (UIView *)rectView
{
    if (!_rectView)
    {
        _rectView = [[UIView alloc] init];
        _rectView.size = CGSizeMake(180, 240);
        _rectView.center = CGPointMake(self.width / 2, self.height / 2);
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.rectView.bounds];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_rectView addSubview:self.imageView];
        
        self.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book_icon_1"]];
        [self.iconView sizeToFit];
        self.iconView.right = _rectView.width;
        self.iconView.hidden = YES;
        [_rectView addSubview:self.iconView];
    }
    return _rectView;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton)
    {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"book_icon_2"] forState:UIControlStateNormal];
        [_deleteButton sizeToFit];
        [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.hidden = YES;
    }
    return _deleteButton;
}

- (UIView *)markView
{
    if (!_markView)
    {
        _markView = [[UIView alloc] initWithFrame:self.rectView.bounds];
        _markView.backgroundColor = RGBCOLOR(0, 0, 0, .5);
        _markView.hidden = YES;
        
        self.pressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
        self.pressLabel.centerX = _markView.width / 2;
        self.pressLabel.font = FONT_WITH_18;
        self.pressLabel.textColor = [UIColor whiteColor];
        self.pressLabel.textAlignment = NSTextAlignmentCenter;
        [_markView addSubview:self.pressLabel];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:self.pressLabel.frame];
        self.statusLabel.top = self.pressLabel.bottom + 10;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [_markView addSubview:self.statusLabel];
        
        [self.rectView addSubview:_markView];
    }
    return _markView;
}

#pragma mark ACTION
- (void)deleteAction
{
    WS(weak)
    [ARTAlertView alertTitle:@"警告" message:@"确定删除该图集?" doneTitle:@"删除" cancelTitle:@"取消" doneBlock:^{
        ARTBookDownObject *object = [[ARTDownLoadManager sharedInstance] isDownLoadIng:weak.localData.bookID];
        if (object)
        {
            [object downLoadPause];
        }
        [[ARTDownLoadManager sharedInstance] deleteBook:weak.localData.bookID completion:^{
           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_STATUSCHANGE object:nil];
        }];
        
    } cancelBlock:^{
        
    }];
}


@end
