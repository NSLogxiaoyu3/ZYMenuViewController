//
//  ZYMenuViewController.m
//  ZYMenuViewController-Sample
//
//  Created by magic on 4/25/16.
//  Copyright © 2016 ZeroYear. All rights reserved.
//

#import "ZYMenuViewController.h"
#import <objc/runtime.h>

static NSTimeInterval const kDefaultAnimationDuration = 0.4;

@interface ZYMenuViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign, readwrite) MenuType MenuOpenedType;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) MenuType visibleMenuType;
@property (nonatomic, assign) BOOL isResponsePanGesture;
@property (nonatomic, assign) BOOL isAnimationing;

@end

@implementation ZYMenuViewController

- (id)initWithMainViewController:(UIViewController *)mainViewController leftMenuViewController:(UIViewController *)leftMenuViewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _mainViewController = mainViewController;
        _leftMenuViewController = leftMenuViewController;
        _visibleMenuType = MenuLeft;
        [self addViewController:mainViewController];
        [self addViewController:leftMenuViewController];
    }
    return self;
}

- (id)initWithMainViewController:(UIViewController *)mainViewController rightMenuViewController:(UIViewController *)rightMenuViewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _mainViewController = mainViewController;
        _rightMenuViewController = rightMenuViewController;
        _visibleMenuType = MenuRight;
        [self addViewController:mainViewController];
        [self addViewController:rightMenuViewController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mainViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.mainViewController.view];
    [self.view addSubview:self.containerView];
    
    UIViewController *menuViewController = [self menuViewControllerForMenuType:self.visibleMenuType];
    if (menuViewController != nil) {
        [self.view insertSubview:menuViewController.view belowSubview:self.containerView];
    }
    self.isResponsePanGesture = YES;
    [self setupGestureRecognizers];
}

- (UIViewController *)menuViewControllerForMenuType:(MenuType)menuType {
    UIViewController * sideDrawerViewController = nil;
    if(menuType != MenuNone){
        sideDrawerViewController = [self childViewControllerForMenuType:menuType];
    }
    return sideDrawerViewController;
}

- (UIViewController *)childViewControllerForMenuType:(MenuType)menuType {
    UIViewController * childViewController = nil;
    switch (menuType) {
        case MenuLeft:
            childViewController = self.leftMenuViewController;
            break;
        case MenuRight:
            childViewController = self.rightMenuViewController;
            break;
        case MenuNone:
            break;
    }
    return childViewController;
}

- (void)openMenuType:(MenuType)menuType animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    if (self.MenuOpenedType == menuType && !self.isAnimationing) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(menuViewController:WillOpenMenuType:)]) {
        [self.delegate menuViewController:self WillOpenMenuType:menuType];
    }
    self.MenuOpenedType = menuType;
    
    void (^openMenuBlock)(void) = ^{
        self.containerView.transform = [self openTransformForView:self.containerView];
    };
    
    void (^openCompleteBlock)(BOOL) = ^(BOOL finished) {
        if (finished) {
            if ([self.delegate respondsToSelector:@selector(menuViewController:didOpenMenuType:)]) {
                [self.delegate menuViewController:self didOpenMenuType:menuType];
            }
        }
        
        if (completion) {
            completion(finished);
        }
    };
    
    [self addShadowToViewController:self.mainViewController];
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration ?: kDefaultAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:openMenuBlock
                         completion:openCompleteBlock];
    } else {
        openMenuBlock();
        openCompleteBlock(YES);
    }
    
    [self updateStatusBarStyle];
    
}

- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    if (self.MenuOpenedType == MenuNone && !self.isAnimationing) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(menuViewController:WillCloseMenuType:)]) {
        [self.delegate menuViewController:self WillCloseMenuType:self.MenuOpenedType];
    }
    
    void (^closeMenuBlock)(void) = ^{
        self.containerView.transform = CGAffineTransformIdentity;
    };
    
    void (^closeCompleteBlock)(BOOL) = ^(BOOL finished) {
        if (finished) {
            if ([self.delegate respondsToSelector:@selector(menuViewController:didCloseMenuType:)]) {
                [self.delegate menuViewController:self didCloseMenuType:self.MenuOpenedType];
            }
            self.MenuOpenedType = MenuNone;
            [self removeShadowFromViewController:self.mainViewController];
        }
        
        if (completion) {
            completion(finished);
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration ?: kDefaultAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:closeMenuBlock
                         completion:closeCompleteBlock];
    } else {
        closeMenuBlock();
        closeCompleteBlock(YES);
    }
}

- (void)toggleMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    if (self.MenuOpenedType == MenuNone) {
        [self openMenuType:self.visibleMenuType animated:animated completion:completion];
    } else {
        [self closeMenuAnimated:animated completion:completion];
    }
    
}

- (CGAffineTransform)openTransformForView:(UIView *)view {
    CGFloat transformSize = self.zoomScale;
    CGAffineTransform newTransform;
    if (self.visibleMenuType == MenuLeft) {
        newTransform = CGAffineTransformMakeTranslation(self.view.frame.size.width - self.edgeOffset.horizontal, self.edgeOffset.vertical);
    } else if (self.visibleMenuType == MenuRight) {
        newTransform = CGAffineTransformMakeTranslation(- self.view.frame.size.width - self.edgeOffset.horizontal, self.edgeOffset.vertical);
    }
    return CGAffineTransformScale(newTransform, transformSize, transformSize);
}

- (void)updateStatusBarStyle {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - Shadow management

- (void)addShadowToViewController:(UIViewController *)viewController {
    CALayer *mainLayer = viewController.view.layer;
    if (mainLayer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:mainLayer.bounds];
        mainLayer.shadowPath = path.CGPath;
        mainLayer.shadowColor = self.shadowColor.CGColor;
        mainLayer.shadowOffset = CGSizeZero;
        mainLayer.shadowOpacity = self.shadowOpacity ?: 0.6f;
        mainLayer.shadowRadius = self.shadowOpacity ?: 10.0f;
    }
}

- (void)removeShadowFromViewController:(UIViewController *)viewController {
    CALayer *mainLayer = viewController.view.layer;
    if (mainLayer) {
        mainLayer.shadowOpacity = 0.0f;
    }
}

- (void)addViewController:(UIViewController *)viewController {
    viewController.zyMenuViewController = self;
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
}

- (void)setupGestureRecognizers {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}

- (void)panGestureCallback:(UIPanGestureRecognizer *)panGesture {
    CGPoint translationPoint = [panGesture translationInView:self.containerView];
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            if (self.MenuOpenedType == MenuNone) {
                CGPoint point = [panGesture locationInView:self.view];
                if (self.visibleMenuType == MenuRight) {
                    if (point.x / self.view.frame.size.width < 0.8) {
                        self.isResponsePanGesture = NO;
                        break;
                    }
                } else {
                    if (point.x / self.view.frame.size.width > 0.2) {
                        self.isResponsePanGesture = NO;
                        break;
                    }
                }
                [self addShadowToViewController:self.mainViewController];
            }
            self.isAnimationing = YES;
            if (self.MenuOpenedType == MenuNone) {
                if ([self.delegate respondsToSelector:@selector(menuViewController:WillOpenMenuType:)]) {
                    [self.delegate menuViewController:self WillOpenMenuType:self.visibleMenuType];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(menuViewController:WillCloseMenuType:)]) {
                    [self.delegate menuViewController:self WillCloseMenuType:self.visibleMenuType];
                }
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (self.isResponsePanGesture && self.isAnimationing) {
                float percent;
                if (translationPoint.x > 0) {
                    if (self.visibleMenuType == MenuLeft && self.MenuOpenedType == MenuLeft) {
                        break;
                    }
                    if (self.visibleMenuType == MenuRight && self.MenuOpenedType == MenuNone) {
                        break;
                    }
                    percent = 1 - translationPoint.x / self.view.frame.size.width;
                } else {
                    if (self.visibleMenuType == MenuLeft && self.MenuOpenedType == MenuNone) {
                        break;
                    }
                    if (self.visibleMenuType == MenuRight && self.MenuOpenedType == MenuRight) {
                        break;
                    }
                    percent = -translationPoint.x / self.view.frame.size.width;
                }
                percent = MIN(percent, 1);
                percent = MAX(percent, 0);
                CGAffineTransform newTransform;
                if (self.visibleMenuType == MenuLeft) {
                    newTransform = CGAffineTransformMakeTranslation((1 - percent) * (self.view.frame.size.width - self.edgeOffset.horizontal), self.edgeOffset.vertical);
                    self.containerView.transform = CGAffineTransformScale(newTransform, percent * (1 - self.zoomScale) + self.zoomScale, percent * (1 - self.zoomScale) + self.zoomScale);
                } else {
                    newTransform = CGAffineTransformMakeTranslation(-percent * (self.view.frame.size.width + self.edgeOffset.horizontal), self.edgeOffset.vertical);
                    self.containerView.transform = CGAffineTransformScale(newTransform,  1 - percent * (1 - self.zoomScale), 1 - percent * (1 - self.zoomScale));
                }
                
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            self.isResponsePanGesture = YES;
            if (!self.isAnimationing) {
                break;
            }
            BOOL isOverMidX = fabs(self.containerView.transform.tx)  / self.zoomScale >= self.view.frame.size.width / 2.0;
            if (translationPoint.x > 0) {
                if (self.visibleMenuType == MenuLeft && self.MenuOpenedType == MenuLeft) {
                    break;
                }
                if (self.visibleMenuType == MenuRight && self.MenuOpenedType == MenuNone) {
                    break;
                }
                if (self.visibleMenuType == MenuLeft && isOverMidX) {
                    [self openMenuType:self.visibleMenuType animated:YES completion:^(BOOL finished) {
                        if ([self.delegate respondsToSelector:@selector(menuViewController:didOpenMenuType:)]) {
                            [self.delegate menuViewController:self didOpenMenuType:self.visibleMenuType];
                        }
                        self.isAnimationing = NO;
                    }];
                } else {
                    [self closeMenuAnimated:YES completion:^(BOOL finished) {
                        if ([self.delegate respondsToSelector:@selector(menuViewController:didCloseMenuType:)]) {
                            [self.delegate menuViewController:self didCloseMenuType:self.visibleMenuType];
                        }
                        self.isAnimationing = NO;
                    }];
                }
            } else {
                if (self.visibleMenuType == MenuLeft && self.MenuOpenedType == MenuNone) {
                    break;
                }
                if (self.visibleMenuType == MenuRight && self.MenuOpenedType == MenuRight) {
                    break;
                }
                if (self.visibleMenuType == MenuRight && isOverMidX) {
                    [self openMenuType:self.visibleMenuType animated:YES completion:^(BOOL finished) {
                        if ([self.delegate respondsToSelector:@selector(menuViewController:didOpenMenuType:)]) {
                            [self.delegate menuViewController:self didOpenMenuType:self.visibleMenuType];
                        }
                        self.isAnimationing = NO;
                    }];
                    
                } else {
                    [self closeMenuAnimated:YES completion:^(BOOL finished) {
                        if ([self.delegate respondsToSelector:@selector(menuViewController:didCloseMenuType:)]) {
                            [self.delegate menuViewController:self didCloseMenuType:self.visibleMenuType];
                        }
                        self.isAnimationing = NO;
                    }];
                }
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UIViewController (ZYMenuViewController)

- (void)setZyMenuViewController:(ZYMenuViewController *)zyMenuViewController
{
    objc_setAssociatedObject(self, @selector(zyMenuViewController), zyMenuViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (ZYMenuViewController *)zyMenuViewController
{
    ZYMenuViewController *zyMenuViewController = objc_getAssociatedObject(self, @selector(zyMenuViewController));
    if (!zyMenuViewController) {
        zyMenuViewController = self.parentViewController.zyMenuViewController;
    }
    return zyMenuViewController;
}

@end
