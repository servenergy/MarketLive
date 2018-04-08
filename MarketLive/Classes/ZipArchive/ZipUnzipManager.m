//
//  ZipUnzipManager.m
//  BSDownlaoding-Module
//
//  Created by BBI_Bhushan on 12/06/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "ZipUnzipManager.h"
@implementation ZipUnzipManager

+(void)unZipFileToLocation:(NSString*)fromPath toPath:(NSString*)toPath{
    ZipArchive *zipArchive = [ZipArchive new];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    @try {
        if([fileManager fileExistsAtPath:fromPath])
        {
            if([zipArchive UnzipOpenFile:fromPath])
            {
                BOOL ret = [zipArchive UnzipFileTo:toPath overWrite:YES];
                if(ret){
                    ////NSLog(@"File unzipped successfully..");
                    ////NSLog(@" Deleting zip From path:%@",fromPath);
                    [fileManager removeItemAtPath:fromPath error:&err];
                }else{
                    ////NSLog(@"Error file can not be unzipped..");
                }
            }
        }else{
            ////NSLog(@"Zip file not present/downloaded...");
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"Exception --> %s %d",__FUNCTION__,__LINE__);
    }
    @finally {
        
        [zipArchive UnzipCloseFile];
    }
}





+(BOOL) unZipFileToLocationWithResult:(NSString*)fromPath toPath:(NSString*)toPath{
    ZipArchive *zipArchive = [ZipArchive new];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    @try {
        if([fileManager fileExistsAtPath:fromPath])
        {
            if([zipArchive UnzipOpenFile:fromPath])
            {
                BOOL ret = [zipArchive UnzipFileTo:toPath overWrite:YES];
                if(ret){
                    //NSLog(@"File unzipped successfully..");
                    [fileManager removeItemAtPath:fromPath error:&err];
                    return YES;
                }
                else
                {
                    //NSLog(@"Error file can not be unzipped..");
                    return NO;
                }
            }
        }
        else
        {
            //NSLog(@"Zip file not present/downloaded...");
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        
        [zipArchive UnzipCloseFile];
    }
}


-(BOOL) zipFileToLocation:(NSString*)path
{
    BOOL isDir=NO;
    
    NSArray *subpaths;
    NSString *exportPath = path;//[docDirectory stringByAppendingPathComponent:@"Other"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:exportPath isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:exportPath];
    }
    if ([fileManager fileExistsAtPath:[DocumentsDirectory stringByAppendingPathComponent:@"Other.zip"]])
    {
        [fileManager removeItemAtPath:[DocumentsDirectory stringByAppendingPathComponent:@"Other.zip"] error:nil];
    }
    
    
    NSString *archivePath = [path stringByAppendingString:@".zip"];
    
    ZipArchive *archiver = [[ZipArchive alloc] init];
    [archiver CreateZipFile2:archivePath];
    for(NSString *path in subpaths)
    {
        NSString *longPath = [exportPath stringByAppendingPathComponent:path];
        if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir)
        {
            [archiver addFileToZip:longPath newname:path];
        }
    }
    
    BOOL successCompressing = [archiver CloseZipFile2];
    if(successCompressing)
    {
        
        return YES;
    }
    else
    {
        //NSLog(@"XX Fail");
        return NO;
    }
}





@end
