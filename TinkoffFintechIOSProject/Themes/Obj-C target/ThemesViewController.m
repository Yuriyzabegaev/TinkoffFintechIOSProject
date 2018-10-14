//
//  ThemesViewController.m
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 11/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

#import "ThemesViewController.h"
#import "ThemesViewControllerDelegate.h"


@implementation ThemesViewController

//MARK: - Properties


@synthesize model = _model;
-(Themes *) model {
    return [[_model retain] autorelease];
}
-(void) setModel:(Themes *)model {
    [_model autorelease];
    _model = [model retain];
}

@synthesize delegate = _delegate;
-(id<ThemesViewControllerDelegate>)delegate {
    return _delegate;
}
-(void)setDelegate:(id<ThemesViewControllerDelegate>)delegate {
    _delegate = delegate;
}


//MARK: - Lifecycle

-(void) viewDidLoad {
    [super viewDidLoad];
        
    self->_model = [[Themes alloc] init];
    
    UIColor * theme = [self getThemeForKey:@"Theme"];
    if (theme != nil) {
        self.view.backgroundColor = theme;
        self.navigationController.navigationBar.barTintColor = theme;
    }
}


//MARK: - Actions

-(IBAction) themePicked:(UIButton *)sender {
    UIColor * newTheme = [self.model getTheme: sender.tag];
    [self changeThemeTo: newTheme];
}

- (IBAction)dismissScreen:(UIButton *)sender {
    [self dismissViewControllerAnimated: true completion: nil];
}


//MARK: - Private methods

-(void) changeThemeTo: (UIColor *)theme {
    self.view.backgroundColor = theme;
    if (self.navigationController != nil) {
        self.navigationController.navigationBar.barTintColor = theme;
    }
    [_delegate themesViewController:self didSelectTheme: theme];

}

-(UIColor *) getThemeForKey: (NSString *)key {
    NSData * themeData = [NSUserDefaults.standardUserDefaults dataForKey: key];
    UIColor * theme = nil;
    if (themeData != nil) {
        theme = [NSKeyedUnarchiver unarchivedObjectOfClass: UIColor.class fromData:themeData error: nil];
    }
    return theme;
}


//MARK: - Deallocation
- (void)dealloc {
    [_model release];
    [super dealloc];
}
@end
