//
//  ARTLocalCell.h
//  ART
//
//  Created by huangtie on 16/6/8.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTBookLocalData;
@interface ARTLocalCell : UICollectionViewCell

- (void)updateData:(ARTBookLocalData *)data isDelete:(BOOL)isDelete;

@end
