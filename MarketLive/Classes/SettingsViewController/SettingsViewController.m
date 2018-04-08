//
//  SettingsViewController.m
//  MarketLive
//
//  Created by Vinod on 11/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "SettingsViewController.h"
#import "LanguageCell.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [objLanguageTable setHidden:YES];
    
    if ([selectedLanguage isEqualToString:@"1"]) {
        
        [languageButtons setTitle:@"English" forState:UIControlStateNormal];
    }
    else if ([selectedLanguage isEqualToString:@"2"]) {
        
        [languageButtons setTitle:@"Hindi" forState:UIControlStateNormal];
    }
    else if ([selectedLanguage isEqualToString:@"3"]) {
        
        [languageButtons setTitle:@"Marathi" forState:UIControlStateNormal];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)languageButtonClicked:(id)sender
{
    [objLanguageTable setHidden:NO];
    [objLanguageTable reloadData];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"languageCell";
    LanguageCell * objTableViewCell = (LanguageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    switch (indexPath.row) {
        case 0:
            [objTableViewCell.languageButton setTitle:@"English" forState:UIControlStateNormal];
            break;
        case 1:
            [objTableViewCell.languageButton setTitle:@"Hindi" forState:UIControlStateNormal];
            break;
        case 2:
            [objTableViewCell.languageButton setTitle:@"Marathi" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
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
    return 30;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [objLanguageTable setHidden:YES];
    LanguageCell * objTableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [languageButtons setTitle:objTableViewCell.languageButton.titleLabel.text forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld", indexPath.row + 1] forKey:@"selectedLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
