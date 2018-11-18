//
//  Themes.m
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 11/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

#import "Themes.h"

@implementation Themes

//MARK: - properties

@synthesize theme1 = _theme1;
-(UIColor *) theme1 {
    return [_theme1 retain];
}
-(void) setTheme1:(UIColor *)theme1 {
    if (_theme1 == theme1) {
        return;
    }
    [_theme1 release];
    _theme1 = [theme1 retain];
}

@synthesize theme2 = _theme2;
-(UIColor *) theme2 {
    return [_theme2 retain];
}
-(void) setTheme2:(UIColor *)theme2 {
    if (_theme2 == theme2) {
        return;
    }
    [_theme2 release];
    _theme2 = [theme2 retain];
}

@synthesize theme3 = _theme3;
-(UIColor *) theme3 {
    return [_theme3 retain];
}
-(void) setTheme3:(UIColor *)theme3 {
    if (_theme3 == theme3) {
        return;
    }
    [_theme3 release];
    _theme3 = [theme3 retain];
}


//MARK: - initialization

-(instancetype) init {
    if (self = [super init]) {
        self->_theme1 = [[UIColor alloc] initWithRed:40/255.0 green:42/255.0 blue:53/255.0 alpha:1];
        self->_theme2 = [UIColor whiteColor];
        self->_theme3 = [[UIColor alloc] initWithRed:249/255.0 green:231/255.0 blue:53/255.0 alpha:1];
    }
    return self;
}


//MARK: - public methods

-(UIColor *) getTheme: (NSInteger) identifier {
    switch (identifier) {
        case 3:
            return self.theme3;
        case 2:
            return self.theme2;
        default:
            return self.theme1;
    }
}


//MARK: - Deallocation

- (void)dealloc {
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    [super dealloc];
}
@end
