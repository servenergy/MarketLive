//
//  UIColor+HexColor.m
//  Modular App
//
//  Created by BBIM1015 on 19/05/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)




+ (UIColor *)colorWithHexArray:(NSArray *) colorArray;
{
    @try {
        NSMutableArray * rgbColorArray = [[NSMutableArray alloc] init];
        
        if ([colorArray isKindOfClass:[NSArray class]])
        {
        for (NSString * hexColor in colorArray)
        {
            NSString *cString = [[hexColor stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
            
            
            // String empty then show clear color
            if ([cString length]==0) return [UIColor clearColor];
            
            
            // String should be 6 or 8 characters
            if ([cString length] < 6) return [UIColor grayColor];
            
            // strip 0X if it appears
            if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
            
            // # replace with blank space
            if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
            
            
            if ([cString length] != 6) return  [UIColor grayColor];
            
            // Separate into r, g, b substrings
            NSRange range;
            range.location = 0;
            range.length = 2;
            NSString *rString = [cString substringWithRange:range];
            
            range.location = 2;
            NSString *gString = [cString substringWithRange:range];
            
            range.location = 4;
            NSString *bString = [cString substringWithRange:range];
            
            // Scan values
            unsigned int r, g, b;
            [[NSScanner scannerWithString:rString] scanHexInt:&r];
            [[NSScanner scannerWithString:gString] scanHexInt:&g];
            [[NSScanner scannerWithString:bString] scanHexInt:&b];
            
            UIColor * color = [UIColor colorWithRed:((float) r / 255.0f)
                                              green:((float) g / 255.0f)
                                               blue:((float) b / 255.0f)
                                              alpha:1.0f];
            
            [rgbColorArray addObject:color];
            return [rgbColorArray objectAtIndex:0];
        }
        }
        else
        {
            NSString * colorArray1 = [NSString stringWithFormat:@"%@",colorArray];
            
            NSString *cString = [[colorArray1 stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
            
            
            // String empty then show clear color
            if ([cString length]==0) return [UIColor clearColor];
            
            
            // String should be 6 or 8 characters
            if ([cString length] < 6) return [UIColor grayColor];
            
            // strip 0X if it appears
            if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
            
            // # replace with blank space
            if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
            
            
            if ([cString length] != 6) return  [UIColor grayColor];
            
            // Separate into r, g, b substrings
            NSRange range;
            range.location = 0;
            range.length = 2;
            NSString *rString = [cString substringWithRange:range];
            
            range.location = 2;
            NSString *gString = [cString substringWithRange:range];
            
            range.location = 4;
            NSString *bString = [cString substringWithRange:range];
            
            // Scan values
            unsigned int r, g, b;
            [[NSScanner scannerWithString:rString] scanHexInt:&r];
            [[NSScanner scannerWithString:gString] scanHexInt:&g];
            [[NSScanner scannerWithString:bString] scanHexInt:&b];
            
            UIColor * color = [UIColor colorWithRed:((float) r / 255.0f)
                                              green:((float) g / 255.0f)
                                               blue:((float) b / 255.0f)
                                              alpha:1.0f];
            
            [rgbColorArray addObject:color];
            return [rgbColorArray objectAtIndex:0];
        }
        
        return [UIColor clearColor];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }
    @finally {
        
    }
    return [UIColor clearColor];
}

+(UIImage *)setImageWithName:(NSString *)imageName andFromWhichModule:(int)moduleName
{
    return nil;
    
}





@end
