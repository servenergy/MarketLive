//
//  UIColor+HexColor.h
//  Modular App
//
//  Created by BBIM1015 on 19/05/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
// send hex color codes array and it will return UIColor
+ (UIColor *)colorWithHexArray:(NSArray *) colorArray;
+(UIImage *)setImageWithName:(NSString *)imageName andFromWhichModule:(int)moduleName;
@end
