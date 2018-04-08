//
//  ZipUnzipManager.h
//  BSDownlaoding-Module
//
//  Created by BBI_Bhushan on 12/06/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipUnzipManager : NSObject

+(void)unZipFileToLocation:(NSString*)fromPath toPath:(NSString*)toPath;
-(BOOL) zipFileToLocation:(NSString*)path;
+(BOOL) unZipFileToLocationWithResult:(NSString*)fromPath toPath:(NSString*)toPath;

@end
