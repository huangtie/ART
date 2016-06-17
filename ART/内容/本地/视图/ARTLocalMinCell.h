//
//  ARTLocalMinCell.h
//  ART
//
//  Created by huangtie on 16/6/17.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTBookLocalData.h"

@protocol ARTLocalMinCellDelegate <NSObject>

- (void)cellDidSelect:(ARTBookPhotoData *)data;

@end

@interface ARTLocalMinCell : UICollectionViewCell

@property (nonatomic , assign) id <ARTLocalMinCellDelegate> delegate;

- (void)update:(ARTBookPhotoData *)data isSelect:(BOOL)isSelect;

@end
