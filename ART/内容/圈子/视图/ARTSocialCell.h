//
//  ARTSocialCell.h
//  ART
//
//  Created by huangtie on 16/6/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ARTSocialCellHeight 72
@interface ARTSocialCell : UITableViewCell

- (void)updateData:(NSString *)iconName
         titleName:(NSString *)titleName
           isWhite:(BOOL)isWhite;

- (void)upDateNoRead:(NSInteger)count;

@end
