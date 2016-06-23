//
//  ARTPurchasesCell.h
//  ART
//
//  Created by huangtie on 16/6/22.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTPurchasesData.h"

#define ARTPURCHASESCELL_HEIGHT 50
@interface ARTPurchasesCell : UITableViewCell

- (void)updateData:(ARTPurchasesData *)data isSelect:(BOOL)isSelect;

@end
