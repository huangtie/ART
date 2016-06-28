//
//  ARTAuthorCell.h
//  ART
//
//  Created by huangtie on 16/6/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTAuthorData.h"

@interface ARTAuthorCell : UICollectionViewCell

- (void)bindingWithData:(ARTAuthorData *)data;

@end
