//
//  ARTAccountFollowCell.h
//  ART
//
//  Created by huangtie on 16/7/8.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ARTUserInfo;

typedef enum
{
    ACCOUNT_CELL_TYPE_TALK = 0,              //私信
    ACCOUNT_CELL_TYPE_FOLLOW ,               //关注
}ACCOUNT_CELL_TYPE;

#define ARTACCOUNTFOLLOWCELLHEIGHT 94

@protocol ARTAccountFollowCellDelegate <NSObject>

- (void)accountDidTouchButton:(NSString *)userID;

@end
@interface ARTAccountFollowCell : UITableViewCell

@property (nonatomic , weak) id<ARTAccountFollowCellDelegate> delegate;

- (void)bindingWithData:(ARTUserInfo *)data type:(ACCOUNT_CELL_TYPE)type;

@end
