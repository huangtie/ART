//
//  ViewControllerProtocol.h
//  PageDemo
//
//  Created by dingwenchao on 12/11/15.
//  Copyright © 2015 wenchao. All rights reserved.
//

#ifndef ViewControllerProtocol_h
#define ViewControllerProtocol_h

@protocol QHPageContainerControllerLifeCycleProtocol;

@protocol QHPageContainerControllerProtocol <QHPageContainerControllerLifeCycleProtocol>

@property (strong, nonatomic) NSString *tabTitle;
@property (strong, nonatomic) UITableView *tableView;

@optional
/** 该子ViewController被选中 */
- (void)viewcontroller:(UIViewController *)viewController didSelectedIndex:(NSUInteger)index;

@end

#endif /* ViewControllerProtocol_h */


@protocol QHPageContainerControllerLifeCycleProtocol <NSObject>

@optional
/** 该子ViewController被显示 */
- (void)viewControllerDidShow;
/** 该子ViewController被隐藏 */
- (void)viewControllerDidHide;

@end