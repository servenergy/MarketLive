//
//  SubCategoryViewController.m
//  MarketLive
//
//  Created by Vinod on 07/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "CustomCell.h"

@interface SubCategoryViewController ()
{
    NSArray * subCategoryArray;
}

@end

@implementation SubCategoryViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    subCategoryArray = [[CategoryManager sharedInstance] getSubCategory:[NavigationHolder sharedInstance].selectedMainCategory languageID:selectedLanguage];
    
    NSSortDescriptor *descriptorVendorName = [NSSortDescriptor sortDescriptorWithKey:@"category_name" ascending:YES];
    
    subCategoryArray = [subCategoryArray sortedArrayUsingDescriptors:@[descriptorVendorName]];
    
    
    [btnMainCategoryTitle setTitle:[NavigationHolder sharedInstance].selectedMainCategory.category_name forState:UIControlStateNormal];
    
    objTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    objSearchBar.placeholder = [NSString stringWithFormat:@"Search %@", [NavigationHolder sharedInstance].selectedMainCategory.category_name];
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
    NSInteger count = [subCategoryArray count];
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
    
    MLCategory * objMLCategory = (MLCategory *)[subCategoryArray objectAtIndex:indexPath.row];
    
    [objTableViewCell.categoryTitle setTitle:objMLCategory.category_name forState:UIControlStateNormal];
    
    UIImage * image = [[CategoryManager sharedInstance] getCategoryImage:[NavigationHolder sharedInstance].selectedMainCategory];
    
    [objTableViewCell.categoryImage setBackgroundImage:image forState:UIControlStateNormal];
    
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
    MLCategory * objMLCategory = (MLCategory *)[subCategoryArray objectAtIndex:indexPath.row];
    
    [NavigationHolder sharedInstance].selectedSubCategory = objMLCategory;
    [RequestManager pushViewWithStoryboardIdentifier:@"VendorsListViewController"];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    NSArray * vendors = [[VendorManager sharedInstance] getAllVendorsOfMainCategory:[NavigationHolder sharedInstance].selectedMainCategory languageID:selectedLanguage];
    
    NSPredicate * vendorNamePredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"vendor_name  CONTAINS[cd] '%@'", searchBar.text]];
    
    NSPredicate * vendorAddressPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"address  CONTAINS[cd] '%@'", searchBar.text]];
    
    NSPredicate * vendorTagPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"tags  CONTAINS[cd] '%@'", searchBar.text]];
    
    NSArray * compoundPredicateArray = [[NSArray alloc] initWithObjects:vendorNamePredicate, vendorAddressPredicate, vendorTagPredicate, nil];
    
    NSSortDescriptor *descriptorSubscribed = [NSSortDescriptor sortDescriptorWithKey:@"is_subscribed" ascending:NO];
    NSSortDescriptor *descriptorMmberShip = [NSSortDescriptor sortDescriptorWithKey:@"membership_type" ascending:YES];
    
    NSPredicate * compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:compoundPredicateArray];
    
    [NavigationHolder sharedInstance].filteredVendorArray = [[vendors filteredArrayUsingPredicate:compoundPredicate] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptorSubscribed, descriptorMmberShip, nil ]];
    
    [searchBar resignFirstResponder];
    
    if ([[NavigationHolder sharedInstance].filteredVendorArray count] != 0)
    {
        [RequestManager pushViewWithStoryboardIdentifier:@"VendorsSearchListViewController"];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Vendor not found" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
}

@end
