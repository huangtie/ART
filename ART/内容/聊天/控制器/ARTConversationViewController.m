//
//  ARTConversationViewController.m
//  ART
//
//  Created by huangtie on 16/7/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTConversationViewController.h"
#import "ARTConversationCell.h"
#import "ARTConversationInput.h"
#import <ReactiveCocoa.h>
#import "ARTEmojiKeyboard.h"
#import "ARTAssetsViewController.h"
#import "ARTTalkImageViewController.h"
#import "ARTRecorderControl.h"
#import "EMCDDeviceManager.h"

@interface ARTConversationViewController ()<UITableViewDelegate,UITableViewDataSource,ARTConversationInputDelegate,ARTEmojiKeyboardDelegate,ARTConversationCellDelegate,ARTRecorderControlDelegate>

@property (nonatomic , copy) NSString *chater;

@property (nonatomic , strong) ARTUserInfo *info;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) EMConversation *conversation;

@property (nonatomic , strong) NSMutableArray <EMMessage *>*msgList;

@property (nonatomic , strong) ARTConversationInput *converInput;

@property (nonatomic , strong) ARTEmojiKeyboard *emojiKeyboard;

@property (nonatomic , strong) ARTRecorderControl *recorderControl;


//相册|相机|表情 栏
@property (nonatomic, strong) UIToolbar *inputAccessoryToolbar;
@property (nonatomic, strong) UIBarButtonItem *videoButtonItem;
@property (nonatomic, strong) UIBarButtonItem *imageButtonItem;
@property (nonatomic, strong) UIBarButtonItem *cameraButtonItem;
@property (nonatomic, strong) UIBarButtonItem *emojiButtonItem;


@property (nonatomic , assign) CGFloat inputBottom;
@end

@implementation ARTConversationViewController

+ (ARTConversationViewController *)launchViewController:(UIViewController *)viewController
                                                 chater:(NSString *)chater
                                                   info:(ARTUserInfo *)info
{
    ARTConversationViewController *vc = [[ARTConversationViewController alloc] init];
    vc.chater = chater;
    vc.info = info;
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopAllVoicePlayannimotion];
    self.inputBottom = self.converInput.bottom;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.inputBottom = self.converInput.bottom;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.info.userNick;
    self.view.backgroundColor = UICOLOR_ARGB(0xfff5f5f5);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    WS(weak)
    [RACObserve(self.converInput, height)
     subscribeNext:^(id body){
         CGFloat top = [weak.inputAccessoryToolbar convertRect:weak.inputAccessoryToolbar.bounds toView:weak.view].origin.y;
         weak.converInput.bottom = top;
     }];
    
    [RACObserve(self.converInput, bottom)
     subscribeNext:^(id body){
         weak.tableView.height = weak.view.height - NAVIGATION_HEIGH - (weak.view.height - weak.converInput.top);
         
         if (weak.inputBottom != weak.converInput.bottom)
         {
             [weak scrollToBottom:NO];
         }
     }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH - self.inputAccessoryToolbar.height - self.converInput.height) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UICOLOR_ARGB(0xfff5f5f5);
    [self.view addSubview:self.tableView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发消息" forState:UIControlStateNormal];
    [sendButton setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
    sendButton.titleLabel.font = FONT_WITH_18;
    [sendButton addTarget:self action:@selector(_rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    self.converInput.top = self.tableView.bottom;
    [self.view addSubview:self.converInput];
    
    [self loadMessageData:YES];
    [self scrollToBottom:NO];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (UIView *)inputAccessoryView
{
    return self.inputAccessoryToolbar;
}

- (void)_rightItemClicked:(id)sender
{

}

#pragma mark METHOD
- (UIBarButtonItem *)buttonItem:(NSString *)image helight:(NSString *)helightImage action:(nullable SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:helightImage] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)scrollToBottom:(BOOL)annimotion
{
    if (self.msgList.count && !self.tableView.isDecelerating)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.msgList.count - 1] atScrollPosition:UITableViewScrollPositionTop animated:annimotion];
    }
}

#define SECTIONHEADER_HEIGHT 35
- (UIView *)sectionHeader:(EMMessage *)message
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SECTIONHEADER_HEIGHT)];
    view.backgroundColor = self.view.backgroundColor;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.height = view.height;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = FONT_WITH_18;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.backgroundColor = UICOLOR_ARGB(0xffd2d2d2);
    [timeLabel clipRadius:8 borderWidth:0 borderColor:nil];
    
    NSString *timestamp = STRING_FORMAT_ADC(@(message.timestamp));
    NSString *time = [NSString timeString:timestamp dateFormat:@"MM/dd HH:mm"];
    timeLabel.text = time;
    timeLabel.width = [time widthForFont:timeLabel.font] + 40;
    timeLabel.centerX = view.width / 2;
    [view addSubview:timeLabel];
    return view;
}

- (BOOL)isDisplayTime:(EMMessage *)currenMessage last:(EMMessage *)lastMessage
{
    if (!lastMessage)
    {
        return YES;
    }
    
    if (currenMessage.timestamp - lastMessage.timestamp > 59699)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark GET_SET
- (EMConversation *)conversation
{
    if (!_conversation)
    {
        _conversation = [[ARTEasemobServer services] conversationForChatter:self.chater];
    }
    return _conversation;
}

- (UIToolbar *)inputAccessoryToolbar
{
    if (!_inputAccessoryToolbar)
    {
        _inputAccessoryToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        [_inputAccessoryToolbar setBackgroundImage:[UIImage imageWithColor:UICOLOR_ARGB(0xfff5f5f5)] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [_inputAccessoryToolbar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
        _inputAccessoryToolbar.size = CGSizeMake(SCREEN_WIDTH, 70);
        self.imageButtonItem = [self buttonItem:@"chat_icon_6" helight:@"chat_icon_5" action:@selector(imageItemClicked)];
        self.cameraButtonItem = [self buttonItem:@"chat_icon_2" helight:@"chat_icon_1" action:@selector(cameraItemClicked)];
        self.videoButtonItem = [self buttonItem:@"chat_icon_8" helight:@"chat_icon_7" action:@selector(videoItemClicked)];
        self.emojiButtonItem = [self buttonItem:@"chat_icon_4" helight:@"chat_icon_3" action:@selector(emojiItemClicked)];
        NSArray *barButtonItems = [NSArray arrayWithObjects:
                                   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                   self.imageButtonItem,
                                   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                   self.cameraButtonItem,
                                   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                   self.videoButtonItem,
                                   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                   self.emojiButtonItem,
                                   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                   nil];
        _inputAccessoryToolbar.items = barButtonItems;
    }
    return _inputAccessoryToolbar;
}

- (ARTConversationInput *)converInput
{
    if (!_converInput)
    {
        _converInput = [[ARTConversationInput alloc] init];
        _converInput.delegate = self;
    }
    return _converInput;
}

- (ARTEmojiKeyboard *)emojiKeyboard
{
    if (!_emojiKeyboard)
    {
        _emojiKeyboard = [[ARTEmojiKeyboard alloc] init];
        _emojiKeyboard.delegate = self;
    }
    return _emojiKeyboard;
}

- (ARTRecorderControl *)recorderControl
{
    if (!_recorderControl)
    {
        _recorderControl = [[ARTRecorderControl alloc] init];
        _recorderControl.delegate = self;
    }
    return _recorderControl;
}

#pragma mark ACTITON
- (void)imageItemClicked
{
    ARTAssetsViewController *assetsVC = [[ARTAssetsViewController alloc] init];
    assetsVC.assetStyle = ARTASSET_STYLE_MULTIPLE;
    WS(weak)
    assetsVC.chooseBlock = ^(NSArray *assets)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (ALAsset *asset in assets)
        {
            UIImage *fullScreenImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullResolutionImage] scale:[asset.defaultRepresentation scale] orientation:(UIImageOrientation)[asset.defaultRepresentation orientation]];
            UIImage *image = [fullScreenImage imageOfOrientationUp];
            [array addObject:image];
        }
        [weak sendImageMessages:array];
    };
    [self presentViewController:assetsVC animated:YES completion:nil];
}

- (void)cameraItemClicked
{
    
}

- (void)videoItemClicked
{
    if (self.converInput.textView.inputView && self.converInput.textView.inputView == self.recorderControl)
    {
        self.converInput.textView.inputView = nil;
    }
    else
    {
        self.converInput.textView.inputView = self.recorderControl;
    }
    [self.converInput.textView reloadInputViews];
    if (![self.converInput.textView isFirstResponder])
    {
        [self.converInput.textView becomeFirstResponder];
    }
}

- (void)emojiItemClicked
{
    if (self.converInput.textView.inputView)
    {
        self.converInput.textView.inputView = nil;
    }
    else
    {
        self.converInput.textView.inputView = self.emojiKeyboard;
    }
    [self.converInput.textView reloadInputViews];
    if (![self.converInput.textView isFirstResponder])
    {
        [self.converInput.textView becomeFirstResponder];
    }
}

#pragma mark NOTIFICATION
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:.3 animations:^{
        self.converInput.bottom = self.view.height - rect.size.height;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:.3 animations:^{
        self.converInput.bottom = self.view.height - self.inputAccessoryToolbar.height;
    }];
}

#pragma mark LOAD
- (void)loadMessageData:(BOOL)isRefresh
{
    if (!_msgList)
    {
        _msgList = [NSMutableArray array];
    }
    
    NSString *formId = nil;
    if (!isRefresh && self.msgList.count)
    {
        EMMessage *message = self.msgList.firstObject;
        formId = message.messageId;
    }
    else
    {
        [self.msgList removeAllObjects];
    }
    NSArray *msgs = [self.conversation loadMoreMessagesFromId:formId limit:ARTPAGESIZE.intValue direction:EMMessageSearchDirectionUp];
    [self.msgList insertObjects:msgs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, msgs.count)]];
    [self.tableView reloadData];
}

#pragma mark DELEGAT
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.msgList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"conversationcell";
    ARTConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell)
    {
        cell = [[ARTConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.delegate = self;
    }
    
    [cell bindingData:self.msgList[indexPath.section] info:self.info];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ARTConversationCell cellHeight:self.msgList[indexPath.section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    EMMessage *current = self.msgList[section];
    EMMessage *last = section > 0 ? self.msgList[section - 1] : nil;
    BOOL isShow = [self isDisplayTime:current last:last];
    return isShow ? SECTIONHEADER_HEIGHT : CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EMMessage *current = self.msgList[section];
    EMMessage *last = section > 0 ? self.msgList[section - 1] : nil;
    BOOL isShow = [self isDisplayTime:current last:last];
    return isShow ? [self sectionHeader:current] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.msgList.count)
    {
        if(scrollView.contentOffset.y < 10)
        {
            EMMessage *message = self.msgList.firstObject;
            NSArray *datas = [self.conversation loadMoreMessagesFromId:message.messageId limit:ARTPAGESIZE.intValue direction:EMMessageSearchDirectionUp];
            if (datas.count)
            {
                NSInteger oldCount = self.msgList.count;
                [self.msgList insertObjects:datas atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, datas.count)]];
                
                [self.tableView reloadData];
                if (self.msgList.count >= oldCount)
                {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.msgList.count - oldCount] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
        }
    }
}

#pragma mark DELEGATE_CELL
- (void)cellDidClickResend:(EMMessage *)message
{
    [[EMClient sharedClient].chatManager asyncResendMessage:message progress:^(int progress) {
    } completion:^(EMMessage *message, EMError *error) {
    }];
    [self loadMessageData:YES];
    WS(weak)
    [self performBlock:^{
        [weak scrollToBottom:YES];
    } afterDelay:.3];
}

- (void)cellDidClickImage:(EMMessage *)message
{
    NSMutableArray *msgs = [NSMutableArray array];
    NSMutableArray *pics = [NSMutableArray array];
    for (EMMessage *msg in self.msgList)
    {
        if ([msg.body isKindOfClass:[EMImageMessageBody class]])
        {
            [msgs addObject:msg];
            EMImageMessageBody *body = (EMImageMessageBody *)msg.body;
            [pics addObject:body.remotePath];
        }
    }
    NSInteger index = [msgs indexOfObject:message];
    [ARTTalkImageViewController launchViewController:self URLS:pics index:index];
}

- (void)cellDidClickVoice:(EMMessage *)message
{
    [self stopAllVoicePlayannimotion];
    EMVoiceMessageBody *body = (EMVoiceMessageBody *)message.body;
    body.art_isPlaying = YES;
    [self.tableView reloadData];
    
    WS(weak)
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:body.localPath completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            body.art_isPlaying = NO;
            [weak.tableView reloadData];
        });
    }];
}

- (void)stopAllVoicePlayannimotion
{
    for (EMMessage *msg in self.msgList)
    {
        if ([msg.body isKindOfClass:[EMVoiceMessageBody class]])
        {
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msg.body;
            body.art_isPlaying = NO;
        }
    }
    [self.tableView reloadData];
}

#pragma mark DELEGATE_INPUT
- (void)inputDidTouchSend:(NSString *)text
{
    if (!text.length)
    {
        return;
    }
    
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:[ARTUserManager sharedInstance].userinfo.userInfo.userID to:self.chater body:[[EMTextMessageBody alloc] initWithText:text] ext:nil];
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        [self loadMessageData:YES];
    }];
    [self loadMessageData:YES];
    [self scrollToBottom:YES];
}

- (void)sendImageMessages:(NSArray <UIImage *> *)images
{
    for (UIImage *image in images)
    {
        EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:UIImageJPEGRepresentation(image, 1) thumbnailData:UIImageJPEGRepresentation(image, .4)];
        EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:[ARTUserManager sharedInstance].userinfo.userInfo.userID to:self.chater body:body ext:nil];
        [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
            
        } completion:^(EMMessage *message, EMError *error) {
            [self loadMessageData:YES];
        }];
    }
    [self loadMessageData:YES];
    WS(weak)
    [self performBlock:^{
        [weak scrollToBottom:YES];
    } afterDelay:.3];
    
}

#pragma mark DELEGATE_EMOJIKEYBORAD
- (void)emojiDidClickEmoji:(ARTEmoji *)emoji
{
    //在光标的位置插入表情, 如果选中, 将会被替换
    NSMutableString *mStr = [NSMutableString stringWithString:self.converInput.textView.text];
    
    //获取光标位置
    NSRange rg = self.converInput.textView.selectedRange;
    if (rg.location == NSNotFound)
    {
        rg.location = self.converInput.textView.text.length;
    }
    //替换选中的文字
    [mStr replaceCharactersInRange:rg withString:emoji.chs];
    self.converInput.textView.text = mStr;
    //定位光标
    self.converInput.textView.selectedRange = NSMakeRange(rg.location + emoji.chs.length, 0);

}

- (void)emojiDidClickDelete
{
    //获取光标位置
    NSRange rg = self.converInput.textView.selectedRange;
    if (rg.location == NSNotFound)
    {
        rg.location = self.converInput.textView.text.length;
    }
    for (NSInteger i = rg.location - 1; i >= 0; i--)
    {
        NSString *str = [self.converInput.textView.text substringWithRange:NSMakeRange(rg.location - 1, 1)];
        if (![str isEqualToString:@"]"])
        {
            return;
        }
        str = [self.converInput.textView.text substringWithRange:NSMakeRange(i, 1)];
        if ([str isEqualToString:@"["])
        {
            self.converInput.textView.text = [self.converInput.textView.text substringToIndex:i];
            return;
        }
    }
}

- (void)emojiDidClickSend
{
    [self inputDidTouchSend:self.converInput.textView.text];
    self.converInput.textView.text = @"";
}

- (void)emojiDidClickKeyboard
{
    [self emojiItemClicked];
}

#pragma mark DELEGATE_RECORDE
- (void)recorderDidBeginRecord
{
    [self stopAllVoicePlayannimotion];
}

- (void)recorderDidClickKeyboard
{
    [self videoItemClicked];
}

- (void)recorderDidCancel
{
    [self.view displayTost:@"录音已取消" offsetY:self.view.height / 2 - 100];
}

- (void)recorderDidRecordError:(NSError *)error
{
    [self.view displayTost:@"录音出错" offsetY:self.view.height / 2 - 100];
}

- (void)recorderDidRecordCompletion:(EMVoiceMessageBody *)body
{
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:self.chater to:[ARTUserManager sharedInstance].userinfo.userInfo.userID body:body ext:nil];
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {

    }];
    [self loadMessageData:YES];
    WS(weak)
    [self performBlock:^{
        [weak scrollToBottom:YES];
    } afterDelay:.3];
}



@end
