//
//  ZYMenuViewController.h
//  ZYMenuViewController-Sample
//
//  Created by magic on 4/25/16.
//  Copyright © 2016 ZeroYear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MenuType){
    MenuNone = 0,
    MenuLeft,
    MenuRight,
};

@class ZYMenuViewController;

@protocol ZYMenuViewControllerDelegate <NSObject>
@optional
- (void)menuViewController:(ZYMenuViewController *)menuViewController WillOpenMenuType:(MenuType)menuType;

- (void)menuViewController:(ZYMenuViewController *)menuViewController WillCloseMenuType:(MenuType)menuType;

- (void)menuViewController:(ZYMenuViewController *)menuViewController didOpenMenuType:(MenuType)menuType;

- (void)menuViewController:(ZYMenuViewController *)menuViewController didCloseMenuType:(MenuType)menuType;

- (UIStatusBarStyle)sideMenuViewController:(ZYMenuViewController *)sideMenuViewController statusBarStyleForViewController:(UIViewController *)viewController;

@end

@interface ZYMenuViewController : UIViewController

@property (nonatomic, weak) id<ZYMenuViewControllerDelegate> delegate;

@property (nonatomic, strong) UIViewController *leftMenuViewController;

@property (nonatomic, strong) UIViewController *rightMenuViewController;

@property (nonatomic, strong) UIViewController *mainViewController;

@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, assign, readonly) MenuType MenuOpenedType;

@property (nonatomic, assign) float zoomScale;

@property (nonatomic, assign) UIOffset edgeOffset;

@property (nonatomic, strong) UIColor *shadowColor;

@property (nonatomic, assign) float shadowOpacity;

@property (nonatomic, assign) float shadowRadius;

- (id)initWithMainViewController:(UIViewController *)mainViewController leftMenuViewController:(UIViewController *)leftMenuViewController;

- (id)initWithMainViewController:(UIViewController *)mainViewController rightMenuViewController:(UIViewController *)rightMenuViewController;

@end

@interface ZYMenuViewController (MenuActions)

- (void)openMenuType:(MenuType)menuType animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

- (void)toggleMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end

@interface ZYMenuViewController (MainViewActions)

- (void)setMainViewController:(UIViewController *)mainViewController closeMenu:(BOOL)closeMenu;

@end


@interface UIViewController (ZYMenuViewController)

@property (nonatomic, weak) ZYMenuViewController *zyMenuViewController;

@end
