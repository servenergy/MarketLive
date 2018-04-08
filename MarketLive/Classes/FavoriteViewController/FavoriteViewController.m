//
//  FavoriteViewController.m
//  MarketLive
//
//  Created by Vinod on 10/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "FavoriteViewController.h"
#import "CustomCell.h"

@interface FavoriteViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray * favoriteArray;
    UIButton * placeHolder;
}
@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    objTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    placeHolder = [[UIButton alloc] initWithFrame:CGRectMake(0, (screenHeight - 100)/2, screenWidth, 40)];
    placeHolder.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    placeHolder.titleLabel.font = [UIFont systemFontOfSize:12];
    [placeHolder setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [placeHolder setTitle:@":-) We didn't find anything to show here." forState:UIControlStateNormal];
    [self.view addSubview:placeHolder];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    favoriteArray = [[FavoriteManager sharedInstance] getFavoriteOfLanguage:selectedLanguage];
    [objTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [favoriteArray count];
    
    if(count == 0)
    {
        tableView.hidden = true;
        placeHolder.hidden = false;
        
    }
    else
    {
        tableView.hidden = false;
        placeHolder.hidden = true;
    }
    return count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    CustomCell * objTableViewCell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Vendor * objVendor = (Vendor *)[favoriteArray objectAtIndex:indexPath.row];
    
    [objTableViewCell.categoryTitle setTitle:objVendor.vendor_name forState:UIControlStateNormal];
    return objTableViewCell;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Vendor * objVendor = (Vendor *)[favoriteArray objectAtIndex:indexPath.row];
    
    [NavigationHolder sharedInstance].selectedVendor = objVendor;
    
    [[VendorManager sharedInstance] setCategory:objVendor];
    
    [RequestManager pushViewWithStoryboardIdentifier:@"RootVendorViewController"];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [UIView animateWithDuration:0.5f animations:^(void)
     {
         CustomCell * objTableViewCell = (CustomCell *)[tableView cellForRowAtIndexPath:indexPath];
         objTableViewCell.frame = CGRectMake(screenWidth, objTableViewCell.frame.origin.y,  objTableViewCell.frame.size.width,  objTableViewCell.frame.size.height);
         
     }completion:^(BOOL finished)
     {
         Vendor * objVendor = (Vendor *)[favoriteArray objectAtIndex:indexPath.row];
         [[FavoriteManager sharedInstance] deleteFavoriteWithVendor:objVendor languageID:selectedLanguage];
         favoriteArray = [[FavoriteManager sharedInstance] getFavoriteOfLanguage:selectedLanguage];
         [objTableView reloadData];
     }];
    
}

@end
