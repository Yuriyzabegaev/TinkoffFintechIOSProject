//
//  Themes.h
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 11/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

#ifndef Themes_h
#define Themes_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Themes : NSObject

@property(retain) UIColor *theme1;
@property(retain) UIColor *theme2;
@property(retain) UIColor *theme3;

-(UIColor *) getTheme: (NSInteger) identifier;
@end

#endif /* Themes_h */
