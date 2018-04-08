//
//  ViewController.h
//  MarketLive
//
//  Created by Vinod on 06/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdBannerView.h"
#import "DataChange.h"


@interface HomeViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, ADBannerViewDelegate>
{
    __weak IBOutlet UICollectionView * objCollectionView;
}
@property (strong, nonatomic) IBOutlet UIView *sideView;
@property (strong, nonatomic) IBOutlet UITableView *sideBar;


- (IBAction)weatherButton:(id)sender;



@end

