//
//  ARTMemberLogCell.h
//  ART
//
//  Created by huangtie on 16/6/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTPurchasesLogData.h"

#define ARTMEMBERLOGCELLHEIGHT 80
@interface ARTMemberLogCell : UITableViewCell

- (void)updateData:(ARTPurchasesLogData *)data;

@end
