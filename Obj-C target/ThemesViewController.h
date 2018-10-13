//
//  ThemesViewController.h
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 11/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

#ifndef ThemesViewController_h
#define ThemesViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Themes.h"
#import "ThemesViewControllerDelegate.h"

@interface ThemesViewController : UIViewController

@property(retain) Themes *model;
@property(weak) id<ThemesViewControllerDelegate> delegate;

-(void) viewDidLoad;
-(IBAction) themePicked:(UIButton *)sender;

@end


#endif /* ThemesViewController_h */
