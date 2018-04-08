//
//  CategoryManager.m
//  MarketLive
//
//  Created by Vinod on 06/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "CategoryManager.h"

@implementation CategoryManager

static CategoryManager * instance = nil;

+(CategoryManager*) sharedInstance{
    if(!instance)
    {
        instance = [[CategoryManager alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSArray *) getMainCategory :(NSString *) languageID
{
    NSString * query = [NSString stringWithFormat:@"Select * from Category where %@=0 and %@='%@'", tbl_category_parent_category_id, tbl_category_language_id, languageID];
    
    NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
    
    NSMutableArray * categoryArray = [[NSMutableArray alloc] init];
    
    if (result) {
        for (NSDictionary * dictionary in result) {
            MLCategory * objVendor = [[MLCategory alloc] initWithDictionary:dictionary];
            [categoryArray addObject:objVendor];
        }
    }
    return categoryArray;
}

-(NSArray *) getSubCategory :(MLCategory *) mlCategory languageID:(NSString *) languageID
{
    NSString * query = [NSString stringWithFormat:@"Select * from Category where %@='%ld' and %@='%@'", tbl_category_parent_category_id, mlCategory.category_id, tbl_category_language_id, languageID];
    
    NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
    
    NSMutableArray * categoryArray = [[NSMutableArray alloc] init];
    
    if (result) {
        for (NSDictionary * dictionary in result) {
            MLCategory * objCategory = [[MLCategory alloc] initWithDictionary:dictionary];
            [categoryArray addObject:objCategory];
        }
    }
    return categoryArray;
}

-(void) deleteAllCategories
{
    NSString * query = [NSString stringWithFormat:@"delete from Category"];
    [[DatabaseManager sharedInstance] deleteRecord:query];
}

-(void) updateCategory : (MLCategory *) mlCategory
{
    NSString * query = [NSString stringWithFormat:@"Insert into Category ( %@, %@, %@, %@, %@ ) VALUES ( '%ld', '%@', '%ld', '%ld', '%ld' )", tbl_category_category_id, tbl_category_category_name, tbl_category_parent_category_id, tbl_category_language_id, tbl_category_status, mlCategory.category_id, mlCategory.category_name, mlCategory.parent_category_id, mlCategory.language_id, mlCategory.status];
    
    
    if ([[DatabaseManager sharedInstance] insertRecord:query]) {
        NSLog(@"Category Added %ld -- %@", mlCategory.category_id, mlCategory.category_name);
    }
    else {
        NSLog(@"Category Not Added");
    }
}

-(BOOL) isCategoryExist : (MLCategory *) mlCategory
{
    NSString * query = [NSString stringWithFormat:@"Select * from Category where %@='%ld'", tbl_category_category_id, mlCategory.category_id];
    
    NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
    if(result)
    {
        if(result.count > 0)
        {
            return YES;
        }
    }
    return NO;
}



-(NSString *) getCategoryName : (MLCategory *) mlCategory
{
    NSString * query = [NSString stringWithFormat:@"Select * from Category where %@='%ld'", tbl_category_category_id, mlCategory.category_id];
    
    NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
    if(result)
    {
        if(result.count > 0)
        {
            return [[result objectAtIndex:0] valueForKey:@"vendor_name"];
        }
    }
    return @"";
}

-(UIImage *) getCategoryImage : (MLCategory *) mlCategory
{
    NSString * categoryId = [NSString stringWithFormat:@"%d", (int)mlCategory.category_id];
    
    NSString * imageName = [NSString stringWithFormat:@"Category_%@.png", categoryId];
    
    NSString * imagePath = [NSString stringWithFormat:@"%@/CategoryImages/%@", DocumentsDirectory, imageName];
    
    UIImage *imageObj = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    BOOL canDownload = NO;
    
    if(!imageObj && canDownload)
    {
        imageObj=[UIImage imageNamed:imageName];
        
        NSString * imageURLPath = [NSString stringWithFormat:@"http://www.mlive.co.in/UploadData/CategoryImages/Category_%d.png", (int)mlCategory.category_id];

        
        imageURLPath = [imageURLPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:imageURLPath];
        
        // 2
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                              dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                  if (error == nil)
                                                  {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          UIImage * image = [UIImage imageWithData:data];
                                                          [self setDownloadedImageToLocalStorage:image imageName:imageName categoryId:categoryId];
                                                      });
                                                  }
                                              }];
        
        // 3
        [downloadTask resume];
    }
    
    return imageObj;
}


-(void) setDownloadedImageToLocalStorage : (UIImage *) image imageName : (NSString *) imageName categoryId:(NSString *) categoryId
{
    NSString * folderPath = [DocumentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"CategoryImages"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * imagePath = [folderPath stringByAppendingPathComponent:imageName];
    
    NSLog(@"Category Image Saved : %@", imageName);
    
    NSData *pngData = UIImagePNGRepresentation(image);
    
    [pngData writeToFile:imagePath atomically:YES];
    
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:categoryId forKey:@"CategoryImage"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didCategoryImageDownloaded" object:self userInfo:dictionary];
    
}


-(MLCategory *) getCategoryWithID : (NSInteger) categoryID
{
    NSString * query = [NSString stringWithFormat:@"Select * from Category where %@='%ld'", tbl_category_category_id, categoryID];
    
    NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
    if(result)
    {
        if(result.count > 0)
        {
            
            return [[MLCategory alloc] initWithDictionary:[result objectAtIndex:0]];
        }
    }
    return nil;
}

@end
