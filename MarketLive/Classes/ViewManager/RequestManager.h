//
//  RequestManager.h
//  Bimber
//
//  Created by Vinod on 28/11/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject
{
    
}

+(void) pushViewWithStoryboardIdentifier : (NSString *) identifier;
+(void) presentViewWithStoryboardIdentifier : (NSString *) identifier;

@end
