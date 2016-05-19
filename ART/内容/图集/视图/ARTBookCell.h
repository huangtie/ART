//
//  ARTBookCell.h
//  ART
//
//  Created by huangtie on 16/5/19.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTBookData.h"

@interface ARTBookCell : UICollectionViewCell

- (void)bindingWithData:(ARTBookData *)bookData;

@end
