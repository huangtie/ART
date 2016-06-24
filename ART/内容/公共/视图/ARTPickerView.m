//
//  ARTPickerView.m
//  ART
//
//  Created by huangtie on 16/6/24.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTPickerView.h"

@interface ARTPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic , strong) UIPickerView *pickerView;

@property (nonatomic , strong) UIView *header;
@property (nonatomic , strong) NSArray *textList;
@property (nonatomic , strong) UIView *rect;
@end

@implementation ARTPickerView

+ (ARTPickerView *)showInView:(UIView *)view
                         data:(NSArray <NSString *>*)textList
                    doneBlock:(ARTPickerViewDoneBlock)doneBlock
{
    ARTPickerView *picker = [[ARTPickerView alloc] init];
    picker.doneBlock = doneBlock;
    [picker showInView:view data:textList];
    return picker;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = RGBCOLOR(66, 66, 66, .4);
        WS(weak)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weak dismiss];
        }];
        [self addGestureRecognizer:tap];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.top = self.header.height;
        
        self.rect = [[UIView alloc] init];
        self.rect.backgroundColor = [UIColor whiteColor];
        [self.rect addSubview:self.header];
        [self.rect addSubview:self.pickerView];
        self.rect.size = CGSizeMake(SCREEN_WIDTH, self.header.height + self.pickerView.height);
        [self addSubview:self.rect];
    }
    return self;
}

- (void)showInView:(UIView *)view data:(NSArray *)textList
{
    self.textList = textList;
    [self.pickerView reloadComponent:0];
    
    self.size = view.size;
    [view addSubview:self];
    
    self.rect.top = view.height;
    [view addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.rect.bottom = view.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:.3 animations:^{
        self.rect.top = self.superview.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark GET_SET
- (UIView *)header
{
    if (!_header)
    {
        _header = [[UIView alloc] init];
        _header.size = CGSizeMake(SCREEN_WIDTH, 60);
        _header.backgroundColor = UICOLOR_ARGB(0xff888888);
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton setTitle:@"选择" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        doneButton.titleLabel.font = FONT_WITH_23;
        [doneButton sizeToFit];
        doneButton.height = _header.height;
        doneButton.right = _header.width - 20;
        [doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:doneButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = FONT_WITH_23;
        [cancelButton sizeToFit];
        cancelButton.height = _header.height;
        cancelButton.left = 20;
        [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:cancelButton];
    }
    return _header;
}

#pragma mark ACTION
- (void)doneAction
{
    if (self.doneBlock)
    {
        self.doneBlock([self.pickerView selectedRowInComponent:0]);
    }
    [self dismiss];
}

- (void)cancelAction
{
    [self dismiss];
}

#pragma mark DELEGATE
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.textList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.textList[row];
}

@end
