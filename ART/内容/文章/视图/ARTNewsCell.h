//
//  ARTNewsCell.h
//  ART
//
//  Created by huangtie on 16/6/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTNewsData.h"

#define ARTNEWSCELLHEIGHT 157
@interface ARTNewsCell : UITableViewCell

- (void)updateData:(ARTNewsData *)data isWhite:(BOOL)isWhite;

@end
