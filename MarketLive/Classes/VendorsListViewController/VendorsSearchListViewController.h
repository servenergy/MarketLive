//
//  VendorsSearchListViewController.h
//  MarketLive
//
//  Created by Vinod on 07/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendorsSearchListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView * objTableView;
    __weak IBOutlet UISearchBar * objSearchBar;
}
@end
