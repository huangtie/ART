//
//  ARTBookGroupCell.h
//  ART
//
//  Created by huangtie on 16/5/19.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTGroupData.h"

#define GROUP_CELL_HEIGHT 40
#define GROUP_CELL_WIDTH 175

#define GROUP_CELL_IDENTIFAR @"GROUP_CELL_IDENTIFAR"

@protocol ARTBookGroupCellDelegate <NSObject>
@optional

- (void)bookGroupCellDidSelect:(ARTGroupData *)groupData;

@end

@interface ARTBookGroupCell : UITableViewCell

@property (nonatomic , assign) id<ARTBookGroupCellDelegate> delegate;

- (void)bindingWithData:(ARTGroupData *)groupData isSelect:(BOOL)isSelect;

@end
