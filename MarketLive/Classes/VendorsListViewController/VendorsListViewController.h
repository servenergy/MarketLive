//
//  VendorsListViewController.h
//  MarketLive
//
//  Created by Vinod on 07/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendorsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView * objTableView;
    __weak IBOutlet UIButton * btnSubCategoryTitle;
    __weak IBOutlet UISearchBar * objSearchBar;
}
@end
