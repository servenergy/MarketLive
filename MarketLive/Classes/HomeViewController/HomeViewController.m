//
//  ViewController.m
//  MarketLive
//
//  Created by Vinod on 06/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomCell.h"
#import "BannerCollectionCell.h"
#import "BannerTableCell.h"
#import "ListCollectionViewCell.h"
#import "AdBannerManager.h"
#import "BabyDefault.h"


BOOL babyDefaultShown;

@interface HomeViewController ()
{
    NSArray * categoryArray;
    BOOL isListViewDisplaying;
    UIPageControl * objPageControl;
    BOOL isSideViewOpen;
}

@end

@implementation HomeViewController
@synthesize sideBar,sideView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    
    
    categoryArray = [[CategoryManager sharedInstance] getMainCategory:selectedLanguage];
    
    
    
    NSSortDescriptor *descriptorVendorName = [NSSortDescriptor sortDescriptorWithKey:@"category_name" ascending:YES];
    
    categoryArray = [categoryArray sortedArrayUsingDescriptors:@[descriptorVendorName]];
    
    isListViewDisplaying = [[NSUserDefaults standardUserDefaults] boolForKey:@"HomeViewListDisplayMode"];
    
    
    
    if (babyDefaultShown == NO)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        BabyDefault * objViewController = [storyboard instantiateViewControllerWithIdentifier:@"BabyDefault"];
        
        if (objViewController)
        {
            [self presentViewController:objViewController animated:NO completion:nil];
        }
        
        babyDefaultShown = YES;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didCategoryImageDownloaded:)
                                                 name:@"didCategoryImageDownloaded"
                                               object:nil];
}

-(void) didCategoryImageDownloaded : (id) sender
{
    [objCollectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [objCollectionView reloadData];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --------------   UICollectionView Datasource and Delegate methods


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }
    else
    {
        
        return [categoryArray count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"bannerTableCollectionCell";
        
        BannerCollectionCell * objBannerCollectionCell = (BannerCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        objBannerCollectionCell.backgroundColor = [UIColor whiteColor];
        
        [objBannerCollectionCell.contentView addSubview:[AdBannerView sharedInstance]];
        
        [AdBannerView sharedInstance].delegate = self;
        
        if (!objPageControl) {
            
            objPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, bannerViewHeight + 4, objBannerCollectionCell.contentView.frame.size.width - 8, 8)];
            [objPageControl setPageIndicatorTintColor:appPrimaryColor];
            [objPageControl setCurrentPageIndicatorTintColor:appSecondaryColor];
            [objPageControl setNumberOfPages:[[[AdBannerManager getInstance] getSponsorList] count]];
            [objPageControl setCurrentPage:0];
        }
        [objBannerCollectionCell.contentView addSubview:objPageControl];
        [objBannerCollectionCell.contentView bringSubviewToFront:objPageControl];
        
        return objBannerCollectionCell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"notificationCell";
        
        UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        return cell;
    }
    else
    {
        MLCategory * objMLCategory = (MLCategory *)[categoryArray objectAtIndex:indexPath.row];
        
        UIImage * image = [[CategoryManager sharedInstance] getCategoryImage:objMLCategory];
        
        if (isListViewDisplaying) {
            
            static NSString *CellIdentifier = @"ListCollectionViewCell";
            ListCollectionViewCell * objTableViewCell = (ListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            
            objTableViewCell.categoryTitle.text = objMLCategory.category_name;
            
            objTableViewCell.categoryImage.image = image;
            
            return objTableViewCell;
        }
        else
        {
            static NSString *CellIdentifier = @"cell";
            CustomHomeCollectionCell * objCustomHomeCollectionCell = (CustomHomeCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            
            [objCustomHomeCollectionCell.categoryTitle setTitle:objMLCategory.category_name forState:UIControlStateNormal];
            
            
            if (__IS_IPHONE)
            {
                objCustomHomeCollectionCell.categoryTitle.titleLabel.font = [UIFont systemFontOfSize:9];
                objCustomHomeCollectionCell.imageTop.constant = 10;
            }
            else
            {
                objCustomHomeCollectionCell.categoryTitle.titleLabel.font = [UIFont systemFontOfSize:20];
                objCustomHomeCollectionCell.imageTop.constant = 20;
            }
            
            objCustomHomeCollectionCell.categoryTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            objCustomHomeCollectionCell.imageHeight.constant = objCustomHomeCollectionCell.frame.size.height / 2;
            
            [objCustomHomeCollectionCell.categoryImage setBackgroundImage:image forState:UIControlStateNormal];
            
            return objCustomHomeCollectionCell;
        }
    }
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        
    }
    else if(indexPath.section == 1)
    {
        
    }
    else
    {
        MLCategory * objMLCategory = (MLCategory *)[categoryArray objectAtIndex:indexPath.row];
        
        [NavigationHolder sharedInstance].selectedMainCategory = objMLCategory;
        [RequestManager pushViewWithStoryboardIdentifier:@"SubCategoryViewController"];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        return CGSizeMake(screenWidth - 8, bannerViewHeight + 15 );
    }
    else if(indexPath.section == 1)
    {
        return CGSizeMake(screenWidth - 8, screenWidth / 2 );
    }
    else
    {
        if (isListViewDisplaying)
        {
            return CGSizeMake(screenWidth - 8, 40);
        }
        else
        {
            int gridCount = 4;
            return CGSizeMake(screenWidth / gridCount - 1, screenWidth / gridCount - 1);
        }
    }
}



/*
-(void) navigationBarButtonClicked : (id) sender
{
    UIBarButtonItem * object = (UIBarButtonItem *)sender;
    
    if(object.tag == 1000)
    {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 24)];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(navigationBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        button.tag = 2000;
        self.navigationItem.rightBarButtonItem = barButton;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HomeViewListDisplayMode"];
    }
    else if(object.tag == 2000)
    {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 24)];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"SwitchGridIcon"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(navigationBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        button.tag = 1000;
        self.navigationItem.rightBarButtonItem = barButton;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HomeViewListDisplayMode"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    isListViewDisplaying = [[NSUserDefaults standardUserDefaults] boolForKey:@"HomeViewListDisplayMode"];
    
    [objCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    
}
*/



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
    searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![searchBar.text isEqualToString:@""])
    {
        NSArray * vendors = [[VendorManager sharedInstance] getAllVendors:selectedLanguage];
        
        NSPredicate * vendorNamePredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"vendor_name  CONTAINS[cd] '%@'", searchBar.text]];
        
        NSPredicate * vendorAddressPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"address  CONTAINS[cd] '%@'", searchBar.text]];
        
        NSPredicate * vendorTagPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"tags  CONTAINS[cd] '%@'", searchBar.text]];
        
        NSArray * compoundPredicateArray = [[NSArray alloc] initWithObjects:vendorNamePredicate, vendorAddressPredicate, vendorTagPredicate, nil];
        
        NSSortDescriptor *descriptorVendorName = [NSSortDescriptor sortDescriptorWithKey:@"vendor_name" ascending:YES];
        NSSortDescriptor *descriptorSubscribed = [NSSortDescriptor sortDescriptorWithKey:@"is_subscribed" ascending:NO];
        NSSortDescriptor *descriptorMmberShip = [NSSortDescriptor sortDescriptorWithKey:@"membership_type" ascending:YES];
        
        NSPredicate * compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:compoundPredicateArray];
        
        [NavigationHolder sharedInstance].filteredVendorArray = [[vendors filteredArrayUsingPredicate:compoundPredicate] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptorVendorName, descriptorSubscribed, descriptorMmberShip, nil]];
        
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
}

-(void) bannerIndexDisplayChanged:(NSInteger)index
{
    NSInteger numberOfPages = [objPageControl numberOfPages];
    
    if (numberOfPages <=  index)
    {
        [objPageControl setNumberOfPages:index + 1];
    }
    
    [objPageControl setCurrentPage:index];
}


- (IBAction)weatherButton:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.accuweather.com/en/in/pune/204848/current-weather/204848"]];
    
    
    
}
@end
