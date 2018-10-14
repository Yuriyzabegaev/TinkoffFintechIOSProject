//
//  ThemesViewControllerDelegate.h
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 12/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

#ifndef ThemesViewControllerDelegate_h
#define ThemesViewControllerDelegate_h

#import "ThemesViewController.h"

@class ThemesViewController;

@protocol ThemesViewControllerDelegate<NSObject>
-(void) themesViewController: (ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;
@end

#endif /* ThemesViewControllerDelegate_h */
