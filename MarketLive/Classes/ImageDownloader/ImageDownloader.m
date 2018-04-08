//
//  ImageDownloader.m
//  MarketLive
//
//  Created by Vinod on 30/07/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader () <NSXMLParserDelegate>
{
    NSMutableData * webResponseData;
    NSString * responseString;
    NSString * currentElement;
    
    NSMutableArray * imageArray;
}

@end

@implementation ImageDownloader

static ImageDownloader * instance = nil;

+(ImageDownloader*) sharedInstance
{
    if (instance==nil)
    {
        instance=[[ImageDownloader alloc] init];
    }
    return instance;
}

-(void) downloadImagesOfVendorWithVendorId : (Vendor *) vendor
{
    NSString * soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><getImagePath xmlns=\"http://tempuri.org/\"><vendorId>%ld</vendorId></getImagePath></soap:Body></soap:Envelope>", vendor.vendor_id];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://www.mlive.co.in/getimagecount.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/getImagePath" forHTTPHeaderField:@"SOAPAction"];
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
    
    NSLog(@"XML : %@", theXML);
    
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
    NSLog(@"Log 1 : %@, %@, %@", elementName, namespaceURI, qName);
    
    if ([elementName isEqualToString:@"string"])
    {
        currentElement = elementName;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"Log 2 : %@", string);

    if ([currentElement isEqualToString:@"string"])
    {
        [imageArray addObject:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([imageArray count] > 0)
    {
        [self.delegate didVendorImagesReceived:imageArray];
        
        //http://www.mlive.co.in/upload/41/image17292016%20112056%20PM.png
    }
    else
    {
        [self.delegate didVendorImagesReceived:nil];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"Log 3 : %@, %@", elementName, qName);
}




@end
