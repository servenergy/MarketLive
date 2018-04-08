//
//  NewsCell.h
//  MarketLive
//
//  Created by Vinod on 17/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *newsTitle;
@property (weak, nonatomic) IBOutlet UIButton *newsDescription;

@end
