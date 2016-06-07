//
//  ARTTalkTextView.m
//  ART
//
//  Created by huangtie on 16/6/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkTextView.h"

@interface ARTTalkTextView()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation ARTTalkTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:nil];
        [self addSubview:self.placeHolderLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:nil];
        [self addSubview:self.placeHolderLabel];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ACTION
- (void)textViewTextDidChange
{
    _placeHolderLabel.hidden = self.text.length;
}

#pragma mark GET_SET
- (UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel)
    {
        CGFloat padding = 7;
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, self.width - 2 * padding, 20)];
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _placeHolderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeHolderLabel.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeHolderLabel.textColor = placeholderColor;
}


@end
