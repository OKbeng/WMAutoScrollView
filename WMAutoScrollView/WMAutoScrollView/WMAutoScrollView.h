//
//  WMAutoScrollView.h
//  WMAutoScrollView
//
//  Created by Zhangwenmin on 2018/6/8.
//  Copyright © 2018年 Zhangwenmin. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 * the image is clicked
 */
typedef void(^clickBlock)(NSInteger index);

@interface WMAutoScrollView : UIView
/*
 * init with urlimages
 */
- (instancetype _Nullable )initWMAutoScrollViewWithFrame:(CGRect)rect imageUrlArray:(NSArray * _Nonnull)imageUrlArray;

/*
 * init with images
 */
- (instancetype _Nullable )initWMAutoScrollViewWithFrame:(CGRect)rect imageArray:(NSArray * _Nonnull)imageArray;

/*
 *  scroll time interval
 */
@property(nonatomic,assign)CGFloat second;

/*
 *   is auto scrolling?
 */
@property(nonatomic,assign)BOOL isAuto;

//////////////////////////////// UI style ////////////////////////////////////////////////////
/*
 *   do you want a pagecontroller?
 */
@property(nonatomic,assign)BOOL isPageController;

/*
 *   pagecontroller defaultColor(garyColor)
 */
@property(nonatomic,copy)UIColor * _Nullable defaultColor;

/*
 *   pagecontroller currentColor(orangeColor)
 */
@property(nonatomic,copy)UIColor * _Nullable currentColor;

/*
 * clickBlock
 */
@property(nonatomic,copy)clickBlock _Nullable imageBlock;
@end
