//
//  DatabaseManager.m
//  MarketLive
//
//  Created by Vinod on 11/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "DatabaseManager.h"
#import <sqlite3.h>

@implementation DatabaseManager

static DatabaseManager * instance = nil;
static sqlite3 *database = nil;
sqlite3_stmt *statement = nil;


+(DatabaseManager*) sharedInstance
{
    if(instance == nil)
    {
        instance = [[DatabaseManager alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        NSLog(@"Doc : %@", documentDirectory);
        
        databasePath = [NSString stringWithFormat:@"%@/MarketLiveDB.sqlite", documentDirectory];
        
        [self createBBDatabase];
    }
    return self;
}

-(void) createBBDatabase
{
    if ([[NSFileManager defaultManager] fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            
            NSString * dbStructureFilePath = [[NSBundle mainBundle] pathForResource:@"DBStructure" ofType:@"json"];
            
            NSString * jsonString = [[NSString alloc] initWithContentsOfFile:dbStructureFilePath encoding:NSUTF8StringEncoding error:nil];
            
            NSArray * tableArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
            
            
            for (NSDictionary * objTable in tableArray) {
                NSString * tableName = [objTable valueForKey:@"Table_Name"];
                NSString *baseCreate=@"CREATE TABLE IF NOT EXISTS ";
                NSString *queryString=[NSString stringWithFormat:@"%@%@ (",baseCreate,tableName];
                
                NSArray * columnArray = [objTable objectForKey:@"Fields"];
                
                NSString * columnWithString = @"";
                
                for (NSDictionary * objColumn in columnArray) {
                    
                    NSString * commaString = @"";
                    
                    if([columnArray lastObject] != objColumn)
                        commaString = @",";
                    
                    columnWithString = [NSString stringWithFormat:@"%@ %@ %@ %@%@", columnWithString, [objColumn valueForKey:@"Col_Name"], [objColumn valueForKey:@"Col_Type"], [objColumn valueForKey:@"Col_constraints"], commaString];
                    
                    
                    
                }

                queryString = [NSString stringWithFormat:@"%@ %@)", queryString, columnWithString];
                
                
                char *errMsg;
                
                if (sqlite3_exec(database, [queryString UTF8String], NULL, NULL, &errMsg)
                    != SQLITE_OK)
                {
                    NSLog(@"Failed to create table");
                }
                
            }
            
            
            [self addInitialData];
            sqlite3_close(database);
        }
        else
        {
            NSLog(@"Failed to open/create database");
        }
    }
}


-(void) addInitialData
{
    documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString * categoryFilePath = [[NSBundle mainBundle] pathForResource:@"Category" ofType:@"json"];
    NSString * vendorFilePath = [[NSBundle mainBundle] pathForResource:@"Vendor" ofType:@"json"];
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:categoryFilePath])
    {
        NSString * jsonString = [[NSString alloc] initWithContentsOfFile:categoryFilePath encoding:NSUTF8StringEncoding error:nil];
        
        NSArray * categoryArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        
        for (NSDictionary * dictionary in categoryArray) {
            MLCategory * objCategory = [[MLCategory alloc] initWithDictionary:dictionary];
            [[CategoryManager sharedInstance] updateCategory:objCategory];
        }
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:vendorFilePath])
    {
        NSString * jsonString = [[NSString alloc] initWithContentsOfFile:vendorFilePath encoding:NSUTF8StringEncoding error:nil];
        
        NSArray * vendorArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        
        for (NSDictionary * dictionary in vendorArray) {
            Vendor * objVendor = [[Vendor alloc] initWithDictionary:dictionary];
            [[VendorManager sharedInstance] updateVendor:objVendor];
            
            
        }
    }
}



-(BOOL)checkColumnExistsInTable : (NSString *) tableName columnName : (NSString *) columnName
{
    BOOL columnExists = NO;
    
    
    const char *dbpath = [databasePath UTF8String];
    
    @try {
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            if(sqlite3_prepare_v2(database, [[NSString stringWithFormat:@"select %@ from %@", columnName, tableName] UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                columnExists = YES;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@", [exception description]);
    }
    @finally {
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return columnExists;
    }
    
}


-(BOOL) insertRecord : (NSString *)queryString
{
    const char *dbpath = [databasePath UTF8String];
    
    BOOL executeFlag;
    
    @try {
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            sqlite3_prepare_v2(database, [queryString UTF8String], -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                executeFlag = YES;
            }
            else
            {
                NSAssert1(0, @"Failed to insert values in database with message '%s'.", sqlite3_errmsg(database));
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@", [exception description]);
    }
    @finally {
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return executeFlag;
    }
}

-(BOOL) updateRecord : (NSString *)queryString
{
    const char *dbpath = [databasePath UTF8String];
    
    BOOL executeFlag;
    
    @try {
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            sqlite3_prepare_v2(database, [queryString UTF8String], -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                executeFlag = YES;
            }
            else
            {
                NSAssert1(0, @"UPDATE Query error '%s'.", sqlite3_errmsg(database));
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@", [exception description]);
    }
    @finally {
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return executeFlag;
    }
}

-(BOOL) deleteRecord : (NSString *)queryString
{
    const char *dbpath = [databasePath UTF8String];
    
    BOOL executeFlag;
    
    @try {
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            sqlite3_prepare_v2(database, [queryString UTF8String], -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                executeFlag = YES;
            }
            else
            {
                NSAssert1(0, @"Delete Query error '%s'.", sqlite3_errmsg(database));
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@", [exception description]);
    }
    @finally {
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return executeFlag;
    }
}

-(NSArray *) fetchRecord : (NSString *)queryString
{
    @try {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            NSMutableArray *arrayWithData=[[NSMutableArray alloc] init];
            if (sqlite3_prepare_v2(database, [queryString UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                int columnCount = sqlite3_column_count(statement);
                
                while (sqlite3_step(statement)==SQLITE_ROW)
                {
                    NSMutableDictionary *dataDict=[[NSMutableDictionary alloc] init];
                    for (int columnNumber=0; columnNumber<columnCount; columnNumber++)
                    {
                        NSString* key = [NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, columnNumber)];
                        
                        NSString* value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, columnNumber)];
                        
                        [dataDict setObject:value forKey:key];
                    }
                    [arrayWithData addObject:dataDict];
                }
                
                return [[NSArray alloc] initWithArray:arrayWithData];
            }
            else
            {
                NSAssert1(0, @"Unable to fetch '%s'.", sqlite3_errmsg(database));
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@", [exception description]);
        return  nil;
    }
    @finally {
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
}


-(int) getMaxValue : (NSString *)queryString
{
    @try {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            if (sqlite3_prepare_v2(database, [queryString UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement)==SQLITE_ROW)
                {
                    return sqlite3_column_int(statement, 0);
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@", [exception description]);
        return  0;
    }
    @finally {
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
}


@end
