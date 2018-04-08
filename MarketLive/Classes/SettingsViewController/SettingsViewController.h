//
//  SettingsViewController.h
//  MarketLive
//
//  Created by Vinod on 11/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController < UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView * objLanguageTable;
    __weak IBOutlet UIButton * languageButtons;
}

@end
