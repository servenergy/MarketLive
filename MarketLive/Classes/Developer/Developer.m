//
//  Developer.m
//  Bimber
//
//  Created by Vinod on 05/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "Developer.h"

@implementation Developer

+(void) showDeveloperAlert :(NSString *) message
{
    if([debugMode boolValue]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Developer Error" message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
