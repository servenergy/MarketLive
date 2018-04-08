//
//  InfoViewController.m
//  MarketLive
//
//  Created by Vinod on 10/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "InfoViewController.h"
#import "CustomCell.h"



@interface InfoViewController () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSMutableArray * infoViewArray;
}
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    infoViewArray = [[NSMutableArray alloc] initWithObjects:@"Terms and conditions", @"Contact us", @"Recommend to friend", @"Feedback", @"Information", nil];
    
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
    NSInteger count = [infoViewArray count];
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
    [objTableViewCell.categoryTitle setTitle:[infoViewArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
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
    if (indexPath.row == 2 || indexPath.row == 3) {
        
        NSString * toEmail = @"feedback.servenergy@gmail.com";
        NSString * subject = @"";
        NSString * emailBody = @"";
        
        
        if (indexPath.row == 2)
        {
            toEmail = @"";
            subject = @"Recommend MarketLive App";
            emailBody = @"I hope you would like \"MarketLive App\". You can download it from App Store and Google Play";
        }
        else if(indexPath.row == 3)
        {
            toEmail = @"feedback.servenergy@gmail.com";
            subject = @"Feedback - MarketLive App";
            emailBody = @"";
        }
            
            
        
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            // We must always check whether the current device is configured for sending emails
            if ([mailClass canSendMail])
            {
                [self displayComposerSheet2:toEmail subject:subject emailBody:emailBody];
            }
            else
            {
                [self launchMailAppOnDevice2:toEmail subject:subject emailBody:emailBody];
            }
        }
        else
        {
            [self launchMailAppOnDevice2:toEmail subject:subject emailBody:emailBody];
        }
    }
    else
    {
        [NavigationHolder sharedInstance].infoTitle = [infoViewArray objectAtIndex:indexPath.row];
        [NavigationHolder sharedInstance].infoHTML = [infoViewArray objectAtIndex:indexPath.row];
        
        [RequestManager pushViewWithStoryboardIdentifier:@"CommonWebView"];
    }
}


-(void)displayComposerSheet2:(NSString *)senderEmail subject:(NSString *) subject emailBody:(NSString *) emailBody
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    //feedbk_toAdd
    NSArray *toRecipients = [NSArray arrayWithObjects:senderEmail,nil];
    [picker setToRecipients:toRecipients];
    
    [picker setSubject:subject];
    [picker setMessageBody:emailBody isHTML:YES];
    
    [self.navigationController presentViewController:picker animated:YES completion:Nil];
    
    UIButton *ButtonObj0 = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect screen=[[UIScreen mainScreen]applicationFrame];
    if (screen.size.width<500)
    {
        ButtonObj0.frame = CGRectMake(20, 0, 220, 44);
        [ButtonObj0.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        
        [ButtonObj0.titleLabel setNumberOfLines:2];
    }
    else
    {
        ButtonObj0.frame = CGRectMake(20, 0, 420, 44);
        [ButtonObj0.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [ButtonObj0.titleLabel setNumberOfLines:2];
    }
    [ButtonObj0.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    
    [ButtonObj0 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    NSString *titleString=@"";
    
    [ButtonObj0.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [ButtonObj0 setTitle:titleString forState:UIControlStateNormal];
    
    if([titleString length] > 35)
    {
        [ButtonObj0.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    
    [ButtonObj0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[[[picker viewControllers] lastObject] navigationItem] setTitleView:ButtonObj0];
}

-(void)launchMailAppOnDevice2:(NSString *)senderEmail subject:(NSString *) subject emailBody:(NSString *) emailBody
{
    NSString *toAddress = senderEmail;
    
    NSString *siteLink = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",[toAddress stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [emailBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:siteLink]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
