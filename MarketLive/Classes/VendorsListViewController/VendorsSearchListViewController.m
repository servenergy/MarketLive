//
//  VendorsSearchListViewController.m
//  MarketLive
//
//  Created by Vinod on 07/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "VendorsSearchListViewController.h"
#import "CustomCell.h"

@interface VendorsSearchListViewController ()
{
    NSArray * vendorListArray;
}

@end

@implementation VendorsSearchListViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];

    vendorListArray = [NavigationHolder sharedInstance].filteredVendorArray;
    
    objTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    NSInteger count = [vendorListArray count];
    if(count == 0)
    {
        tableView.hidden = true;
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, screenWidth, 40)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:@":-) We didn't find anything to show here." forState:UIControlStateNormal];
        [self.view addSubview:button];
        
    }
    return count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    CustomCell * objTableViewCell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Vendor * objVendor = (Vendor *)[vendorListArray objectAtIndex:indexPath.row];
    
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
    Vendor * objVendor = (Vendor *)[vendorListArray objectAtIndex:indexPath.row];
    [NavigationHolder sharedInstance].selectedVendor = objVendor;
    [[VendorManager sharedInstance] setCategory:objVendor];
    [RequestManager pushViewWithStoryboardIdentifier:@"RootVendorViewController"];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    
    if ([searchBar.text isEqualToString:@""])
    {
        vendorListArray = [NavigationHolder sharedInstance].filteredVendorArray;
        [objTableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    vendorListArray = [NavigationHolder sharedInstance].filteredVendorArray;
    [objTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSPredicate * vendorNamePredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"vendor_name  CONTAINS[cd] '%@'", searchBar.text]];
    
    NSSortDescriptor *descriptorVendorName = [NSSortDescriptor sortDescriptorWithKey:@"vendor_name" ascending:YES];
    NSSortDescriptor *descriptorSubscribed = [NSSortDescriptor sortDescriptorWithKey:@"is_subscribed" ascending:NO];
    NSSortDescriptor *descriptorMmberShip = [NSSortDescriptor sortDescriptorWithKey:@"membership_type" ascending:YES];
    
    vendorListArray = [[vendorListArray filteredArrayUsingPredicate:vendorNamePredicate] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptorVendorName, descriptorSubscribed, descriptorMmberShip, nil]];
    [objTableView reloadData];
    vendorListArray = [NavigationHolder sharedInstance].filteredVendorArray;

    
}
@end
