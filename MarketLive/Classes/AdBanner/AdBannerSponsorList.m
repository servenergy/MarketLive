//
//  AdBannerJSONWS.m
//  DragDrop
//
//  Created by BBIM1019 on 9/3/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import "AdBannerSponsorList.h"

@interface AdBannerSponsorList () <NSXMLParserDelegate>
{
    NSMutableData * webResponseData;
    NSString * responseString;
    NSString * currentElement;
    
    NSMutableArray * imageArray;
}

@end

@implementation AdBannerSponsorList

static AdBannerSponsorList * instance = nil;

+(AdBannerSponsorList*) getInstance
{
    if (instance==nil)
    {
        instance=[[AdBannerSponsorList alloc] init];
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

-(void) downloadSponsorList
{
    NSString * soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getBanerImages xmlns=\"http://tempuri.org/\" /></soap:Body></soap:Envelope>"];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://www.mlive.co.in/getBannerImages.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    // [theRequest addValue:@"www.w3schools.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/getBanerImages" forHTTPHeaderField:@"SOAPAction"];
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
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webResponseData  appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *theXML = [[NSString alloc] initWithBytes:
                        [webResponseData mutableBytes] length:[webResponseData length] encoding:NSUTF8StringEncoding];
    
    //now parsing the xml
    
    NSData *myData = [theXML dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
    
    //setting delegate of XML parser to self
    xmlParser.delegate = self;
    
    imageArray = [[NSMutableArray alloc] init];
    
    // Run the parser
    @try{
        BOOL parsingResult = [xmlParser parse];
        if(parsingResult)
        {
            //NSLog(@"XML Parse Success");
        }
        else
        {
        }
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
    if ([elementName isEqualToString:@"string"])
    {
        currentElement = elementName;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"string"])
    {
        [imageArray addObject:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([imageArray count] > 0)
    {
        [self.delegate didSponsorImagesReceived:imageArray];
    }
    else
    {
        [self.delegate didSponsorImagesReceived:nil];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

}




@end
