//
//  ARTHtmlView.h
//  ART
//
//  Created by huangtie on 16/5/30.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"

typedef void(^ARTHtmlLoadFinishBlock)(CGFloat contrlHeight);

@interface ARTHtmlView : UIWebView

@property (nonatomic , copy) NSString *content;

@property (nonatomic , assign) NSInteger webHeight;

@property (nonatomic , copy) ARTHtmlLoadFinishBlock loadFinishBlock;

- (instancetype)initWithContent:(NSString *)content;

@end
