//
//  NewsViewController.m
//  MarketLive
//
//  Created by Vinod on 11/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsManager.h"

@interface NewsViewController ()
{
    NSArray * newsArray;
    UIButton * placeHolder;
}
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    newsArray = [[NewsManager getInstance] getNews];
    
    objTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NewsManager getInstance] checkForUpdates];
    
    
    placeHolder = [[UIButton alloc] initWithFrame:CGRectMake(0, (screenHeight - 100)/2, screenWidth, 40)];
    placeHolder.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    placeHolder.titleLabel.font = [UIFont systemFontOfSize:12];
    [placeHolder setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [placeHolder setTitle:@":-) We didn't find anything to show here." forState:UIControlStateNormal];
    [self.view addSubview:placeHolder];
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
    if ([newsArray count])
    {
        [objTableView setHidden:NO];
        placeHolder.hidden = true;
        return [newsArray count];
    }
    else
    {
        [objTableView setHidden:YES];
        placeHolder.hidden = false;
        return 0;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newsCell";
    NewsCell * objNewsCell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    News * objNews = (News *)[newsArray objectAtIndex:indexPath.row];
    
    [objNewsCell.newsTitle setTitle:objNews.newsTitle forState:UIControlStateNormal];
    [objNewsCell.newsDescription setTitle:objNews.newsDescription forState:UIControlStateNormal];
    
    return objNewsCell;
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
    return 50;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    News * objNews = (News *)[newsArray objectAtIndex:indexPath.row];
    [NavigationHolder sharedInstance].selectedNews = objNews;
    [RequestManager pushViewWithStoryboardIdentifier:@"DetailNewsViewController"];
}

@end
