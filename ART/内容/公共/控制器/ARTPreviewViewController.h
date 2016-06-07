//
//  ARTPreviewViewController.h
//  ART
//
//  Created by huangtie on 16/6/7.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"
#import "ARTAssetsViewController.h"

@interface ARTPreviewImageView : UIScrollView

@end

@interface ARTPreviewViewController : ARTBaseViewController

@property (nonatomic , copy) ARTAssetChooseBlock chooseBlock;

- (instancetype)initWithAssets:(NSArray *)assets index:(NSInteger)index;

@end
