//
//  DatabaseManager.h
//  MarketLive
//
//  Created by Vinod on 11/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject
{
    NSString * documentDirectory;
    NSString * databasePath;
}

+(DatabaseManager*) sharedInstance;
-(BOOL) insertRecord : (NSString *)queryString;
-(BOOL) updateRecord : (NSString *)queryString;
-(BOOL) deleteRecord : (NSString *)queryString;
-(NSArray *) fetchRecord : (NSString *)queryString;
-(int) getMaxValue : (NSString *)queryString;
-(BOOL)checkColumnExistsInTable : (NSString *) tableName columnName : (NSString *) columnName;

@end
