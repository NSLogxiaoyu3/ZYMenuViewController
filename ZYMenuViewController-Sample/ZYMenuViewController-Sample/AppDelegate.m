//
//  AppDelegate.m
//  ZYMenuViewController-Sample
//
//  Created by magic on 4/25/16.
//  Copyright © 2016 ZeroYear. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYMenuViewController.h"
#import "MainViewController.h"
#import "SideMenuViewController.h"

@interface AppDelegate ()<ZYMenuViewControllerDelegate>

@property (nonatomic, strong) ZYMenuViewController *zyMenuViewController;
@property (nonatomic, strong) UIButton *controlButton;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MainViewController *mainVC = (MainViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainVC"];
    SideMenuViewController *sideMenuVC = (SideMenuViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SideMenuVC"];
    
    self.zyMenuViewController = [[ZYMenuViewController alloc] initWithMainViewController:mainVC rightMenuViewController:sideMenuVC];
    self.zyMenuViewController.shadowColor = [UIColor blackColor];
    self.zyMenuViewController.edgeOffset = (UIOffset) {-[UIScreen mainScreen].bounds.size.width * 0.26, 0.0f};
    self.zyMenuViewController.zoomScale = 0.85f;
    self.zyMenuViewController.delegate = self;
    
    self.controlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.controlButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 40, 40, 30);
    [self.controlButton setTitle:@"展开" forState:UIControlStateNormal];
    [self.controlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.controlButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.controlButton addTarget:self action:@selector(control:) forControlEvents:UIControlEventTouchUpInside];
    [self.zyMenuViewController.view addSubview:self.controlButton];
    self.window.rootViewController = self.zyMenuViewController;
    return YES;
}

- (void)control:(UIButton *)sender {
    [self.zyMenuViewController toggleMenuAnimated:YES completion:^(BOOL finished){
//        if (finished) {
//            if (self.zyMenuViewController.MenuOpenedType == MenuNone) {
//                [self.controlButton setTitle:@"展开" forState:UIControlStateNormal];
//            } else {
//                [self.controlButton setTitle:@"关闭" forState:UIControlStateNormal];
//            }
//        }
    }];
}

- (void)menuViewController:(ZYMenuViewController *)menuViewController WillOpenMenuType:(MenuType)menuType {
    
}

- (void)menuViewController:(ZYMenuViewController *)zyMenuViewController didOpenMenuType:(MenuType)menu {
    [self.controlButton setTitle:@"关闭" forState:UIControlStateNormal];
}

- (void)menuViewController:(ZYMenuViewController *)menuViewController WillCloseMenuType:(MenuType)menuType {
    
}

- (void)menuViewController:(ZYMenuViewController *)zyMenuViewController didCloseMenuType:(MenuType)menu {
    [self.controlButton setTitle:@"展开" forState:UIControlStateNormal];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
