//
//  ARTAssetsViewController.h
//  ART
//
//  Created by huangtie on 16/6/7.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, ARTASSET_STYLE)
{
    ARTASSET_STYLE_SINGLE,   //单选
    ARTASSET_STYLE_MULTIPLE  //多选
};

typedef void (^ARTAssetChooseBlock)(NSArray *assets);

@interface ARTAssetsViewController : ARTBaseViewController

@property (nonatomic , assign) ARTASSET_STYLE assetStyle;

@property (nonatomic , copy) ARTAssetChooseBlock chooseBlock;

@property (nonatomic , assign) NSInteger multipleMax;

@end

@interface ARTAssetItem : UICollectionViewCell

- (void)update:(ALAsset *)asset isSelect:(BOOL)isSelect;

@end


