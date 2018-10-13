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
    return [[_theme1 retain] autorelease];
}
-(void) setTheme1:(UIColor *)theme1 {
    [_theme1 autorelease];
    _theme1 = [theme1 retain];
}

@synthesize theme2 = _theme2;
-(UIColor *) theme2 {
    return [[_theme2 retain] autorelease];
}
-(void) setTheme2:(UIColor *)theme2 {
    [_theme2 autorelease];
    _theme2 = [theme2 retain];
}

@synthesize theme3 = _theme3;
-(UIColor *) theme3 {
    return [[_theme3 retain] autorelease];
}
-(void) setTheme3:(UIColor *)theme3 {
    [_theme3 autorelease];
    _theme3 = [theme3 retain];
}


//MARK: - initialization

-(instancetype) init {
    if (self = [super init]) {
        self.theme1 = [UIColor blackColor];
        self.theme2 = [UIColor whiteColor];
        self.theme3 = [UIColor yellowColor];
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
