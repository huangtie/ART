//
//  ARTBookScreen.h
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTBookScreenList : UIView

@end

@class ARTBookScreen;
@protocol ARTBookScreenDelegate <NSObject>
@optional

- (void)screenDidScreen:(ARTBookScreen *)screenView index:(NSInteger)index;

@end

@interface ARTBookScreen : UIView

@property (nonatomic , assign) id<ARTBookScreenDelegate> delegate;

- (instancetype)initWithTitels:(NSArray <NSString *> *)titles;

@end
