//
//  ARTBookComentCell.h
//  ART
//
//  Created by huangtie on 16/5/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTCommentData.h"

@interface ARTBookComentCell : UITableViewCell

- (void)bindingWithData:(ARTCommentData *)commentData isW:(BOOL)isW;

+ (CGFloat)cellHeight:(NSString *)text;

@end
