//
//  ARTConversationInput.m
//  ART
//
//  Created by huangtie on 16/7/14.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTConversationInput.h"
#import <ReactiveCocoa.h>
#import "ARTConversationUtil.h"

@interface ARTConversationInput()<UITextViewDelegate>

@property (nonatomic , strong) UIView *rect;


@end

@implementation ARTConversationInput

#define INPUT_HEIGHT 90
#define LEFT  20
#define TOP 10
#define DEFULT_HEIGHT 36
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, INPUT_HEIGHT);
        self.backgroundColor = UICOLOR_ARGB(0xfff5f5f5);
        
        self.rect = [[UIView alloc] init];
        self.rect.backgroundColor = [UIColor whiteColor];
        self.rect.frame = CGRectMake(LEFT, TOP, SCREEN_WIDTH - 2 * LEFT, INPUT_HEIGHT - 2 * TOP);
        [self.rect clipRadius:10 borderWidth:0 borderColor:nil];
        [self addSubview:self.rect];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(LEFT, (self.rect.height - DEFULT_HEIGHT) / 2, self.rect.width - 2 * LEFT, DEFULT_HEIGHT)];
        self.textView.font = FONT_WITH_20;
        self.textView.textColor = UICOLOR_ARGB(0xff444444);
        self.textView.contentSize = CGSizeMake(self.textView.contentSize.width, 43);
        self.textView.returnKeyType = UIReturnKeySend;
        self.textView.delegate = self;
        [self.rect addSubview:self.textView];
        
        WS(weak);
        [RACObserve(self.textView, contentSize)
         subscribeNext:^(id body){
             CGSize size = weak.textView.contentSize;
             if (size.height > 80)
             {
                 size.height = 80;
             }
             weak.textView.height = size.height;
             [UIView animateWithDuration:.3 animations:^{
                 weak.rect.height = weak.textView.height + 2 * TOP;
                 weak.textView.centerY = weak.rect.height / 2;
                 weak.height = weak.rect.height + 2 * TOP;
             }];
         }];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [self.delegate inputDidTouchSend:textView.text];
        textView.text = @"";
        return NO;
    }
    return YES;
}





























@end
