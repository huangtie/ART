//
//  ARTConversationListCell.m
//  ART
//
//  Created by huangtie on 16/7/21.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTConversationListCell.h"

@implementation ARTConversationListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, ARTCONVERSATIONLISTCELLHEIGHT);
    }
    return self;
}

@end
