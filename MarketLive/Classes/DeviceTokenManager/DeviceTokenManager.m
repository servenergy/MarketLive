//
//  DeviceTokenManager.m
//  ESC 3.0, MB 1.7
//
//  Created by BBIM1019 on 8/11/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import "DeviceTokenManager.h"

@interface DeviceTokenManager ()
{
    NSString * soapMessage;
    NSString * responseString;
    NSString * currentElement;
    NSMutableData * webResponseData;
    
}
@end

@implementation DeviceTokenManager

static DeviceTokenManager * instance = nil;

+(DeviceTokenManager*) sharedInstance
{
    if (instance==nil)
    {
        instance=[[DeviceTokenManager alloc] init];
    }
    return instance;
}

-(id) init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

-(void) saveTokenToServer : (NSString *)tokenID;
{
    NSString  *currentDeviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><Insert xmlns=\"http://tempuri.org/\"><tokenId>%@</tokenId><email>abc@xyz.com</email><opsys>1</opsys><uuid>%@</uuid></Insert></soap:Body></soap:Envelope>", tokenID, currentDeviceId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://www.mlive.co.in/InsertToken.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    // [theRequest addValue:@"www.w3schools.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/Insert" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    NSURLConnection *connection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        webResponseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
}

//Implement the connection delegate methods.
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webResponseData  setLength:0];
    [_delegate didDeviceTokenManagerStarted];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webResponseData  appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_delegate didDeviceTokenManagerFailed];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *theXML = [[NSString alloc] initWithBytes:
                        [webResponseData mutableBytes] length:[webResponseData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"theXML %@", theXML);
    
    NSData *myData = [theXML dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
    
    //setting delegate of XML parser to self
    xmlParser.delegate = self;
    
    // Run the parser
    @try
    {
        /*
        BOOL parsingResult = [xmlParser parse];
        if(parsingResult){
            //NSLog(@"XML Parse Success");
        }
        else
        {
            [_delegate didDeviceTokenManagerFailed];
        }
        */
    }
    @catch (NSException* exception)
    {
        return;
    }
}

//Implement the NSXmlParserDelegate methods
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"return"])
    {
        responseString = @"";
        
    }
    
    currentElement = elementName;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"return"]) {
        responseString = [responseString stringByAppendingString:string];
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSError * error;
    NSData * data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingMutableContainers
                                                            error:&error];
    if (error)
    {
        NSLog(@"DeviceTokenManager-Error :%@", [error description]);
        [_delegate didDeviceTokenManagerFailed];
    }
    else
    {
        NSLog(@"DeviceTokenManager-Response :%@", dict);
        
        //int code = [[dict objectForKey:@"QueryStatus"] intValue];
        
        //[_delegate didDeviceTokenManagerCompletedWithResult:code == 200 ? YES : NO];
        
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}


@end
