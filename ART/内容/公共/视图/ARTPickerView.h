//
//  ARTPickerView.h
//  ART
//
//  Created by huangtie on 16/6/24.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ARTPickerViewDoneBlock)(NSInteger index);
@interface ARTPickerView : UIView

@property (nonatomic , copy) ARTPickerViewDoneBlock doneBlock;

+ (ARTPickerView *)showInView:(UIView *)view
                         data:(NSArray <NSString *>*)textList
                    doneBlock:(ARTPickerViewDoneBlock)doneBlock;

@end
