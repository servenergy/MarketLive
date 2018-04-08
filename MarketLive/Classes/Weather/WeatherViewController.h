//
//  WeatherViewController.h
//  MarketLive
//
//  Created by Admin on 22/03/18.
//  Copyright © 2018 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
        NSMutableArray *maxTempArray;
        NSMutableArray *minTempArray;
        NSMutableArray *dayArray;
    
    __weak IBOutlet UITableView * weatherTableView;
}

@end
