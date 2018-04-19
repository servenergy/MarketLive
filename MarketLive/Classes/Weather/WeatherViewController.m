//
//  WeatherViewController.m
//  MarketLive
//
//  Created by Admin on 22/03/18.
//  Copyright © 2018 Vinod Sutar. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherCell.h"
#import <CoreLocation/CoreLocation.h>


@interface WeatherViewController () <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@end

@implementation WeatherViewController
@synthesize cityLabel,dayLabel,tempLabel,mainImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    maxTempArray = [[NSMutableArray alloc]init];
    minTempArray = [[NSMutableArray alloc]init];
    dayArray = [[NSMutableArray alloc]init];
    weatherImageArray = [[NSMutableArray alloc] init];
    backgroundImageArray = [[NSMutableArray alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    //[self getWeatherDataFromLatitude:@"8.524139" longitude:@"76.936638"];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if ([locations count] > 1) {
        
        
        
        
        CLLocation * oldLocation = [locations objectAtIndex:[locations count] - 2];
        NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);

        
        
    }
    
    CLLocation * newLocation = [locations lastObject];
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);

    [self getWeatherDataFromLatitude:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] longitude:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude]];
}

-(void)getWeatherDataFromLatitude:(NSString *) latitude longitude:(NSString *)longitude {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.darksky.net/forecast/cdc480a3c71ac91c46b31a161c2ff959/%@,%@", latitude, longitude];
    
    NSError *error;
    NSURLResponse *response;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] returningResponse:&response error:&error];
    
    if (data) {
        
        NSData *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        //currently
        
        NSData *currentData = [jsonData valueForKey:@"currently"];
        
        NSString *temperatureString = [currentData valueForKey:@"temperature"];
        
        float fahrenheit = temperatureString.floatValue;
        
        float celsius = (fahrenheit-32.0)*(5.0/9.0);
        
        NSLog(@"temperature in pune in celsius= %.2f",celsius);
        NSLog(@"temperature in pune in fahrenheit= %.2f",fahrenheit);
        
        
        
        //currently
        
        NSData *dayData = [jsonData valueForKey:@"daily"];
        NSArray *dataArray = [dayData valueForKey:@"data"];
        
        NSDate *current = [NSDate date];
        NSInteger weekday = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:current]weekday];
        NSLog(@"weekday: %ld",weekday);
        
        
        
        for (int i =0; i< dataArray.count; i++) {
            
            NSData *tmpData = [dataArray objectAtIndex:i];
            
            NSString *minText = [tmpData valueForKey:@"temperatureMin"];
            NSString *maxText = [tmpData valueForKey:@"temperatureMax"];
            
            NSString *minValue = [self getCelsius:minText.floatValue];
            NSString *maxValue = [self getCelsius:maxText.floatValue];
            
            [minTempArray addObject:minValue];
            [maxTempArray addObject:maxValue];
            
            int day = (int)weekday+i;
            [dayArray addObject:[self getShortCutForDay:day]];
            
            
            
            
            NSString *iconString = [tmpData valueForKey:@"icon"];
            
            if ([iconString isEqualToString:@"clear-day"])
            {
                [weatherImageArray addObject:@"sunn.png"];
                [backgroundImageArray addObject:@"bluee.png"];
            }
            
            else if ([iconString isEqualToString:@"clear-night"])
            {
                [weatherImageArray addObject:@"night.png"];
                [backgroundImageArray addObject:@"bluee.png"];
            }
            
            else if ([iconString isEqualToString:@"rain"])
            {
                [weatherImageArray addObject:@"rain.png"];
                [backgroundImageArray addObject:@"gray.png"];
            }
            else if ([iconString isEqualToString:@"snow"])
            {
                [weatherImageArray addObject:@"snow.png"];
                [backgroundImageArray addObject:@"gray.png"];
            }
            else if ([iconString isEqualToString:@"sleet"])
            {
                [weatherImageArray addObject:@"sleet.png"];
                [backgroundImageArray addObject:@"gray.png"];
            }
            else if ([iconString isEqualToString:@"wind"])
            {
                [weatherImageArray addObject:@"wind.png"];
                [backgroundImageArray addObject:@"gray.png"];
            }
            else if ([iconString isEqualToString:@"fog"])
            {
                [weatherImageArray addObject:@"fog.png"];
                [backgroundImageArray addObject:@"gray.png"];
            }
            else if ([iconString isEqualToString:@"cloudy"])
            {
                [weatherImageArray addObject:@"cloudy.png"];
                [backgroundImageArray addObject:@"gray.png"];
            }
            else if ([iconString isEqualToString:@"partly-cloudy-day"])
            {
                [weatherImageArray addObject:@"partly-cloudy-day-icon.png"];
                [backgroundImageArray addObject:@"gray.png"];
            }
            else
            {
                [weatherImageArray addObject:@"cloudy-night-icon.png"];
                [backgroundImageArray addObject:@"gray.png"];
            }
            
            
        }
          [weatherTableView reloadData];
        
        NSData *tmpData = [dataArray objectAtIndex:0];
        
        
        NSString *maxText = [tmpData valueForKey:@"temperatureMax"];
        
        
        NSString *maxValue = [self getCelsius:maxText.floatValue];
        
        
        [maxTempArray addObject:maxValue];
        
        NSString *iconString = [tmpData valueForKey:@"icon"];
        
        
        
        tempLabel.text = [NSString stringWithFormat:@"MAX: %@' C",[maxTempArray objectAtIndex:0]];
        //dayLabel.text = [NSString stringWithFormat:@"%@",[dayArray objectAtIndex:0]];
        mainImage.image = [UIImage imageNamed:[weatherImageArray objectAtIndex:0]];
        dayLabel.text = [NSString stringWithFormat:@"%@",iconString];
      
    }
    
 
    
    else
    {
        
    }
}

//Deprecated method
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"weatherCell";
    WeatherCell *cell = (WeatherCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.minLbl.text = [NSString stringWithFormat:@"Min: %@' C",[minTempArray objectAtIndex:indexPath.row]];
    cell.MaxLbl.text = [NSString stringWithFormat:@"MAx: %@' C",[maxTempArray objectAtIndex:indexPath.row]];
    cell.dayLbl.text = [NSString stringWithFormat:@"%@",[dayArray objectAtIndex:indexPath.row]];
    cell.weatherImg.image = [UIImage imageNamed:[weatherImageArray objectAtIndex:indexPath.row]];
    cell.bgImg.image = [UIImage imageNamed:[backgroundImageArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 75;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)minTempArray.count;
}

-(NSString *)getShortCutForDay:(int)day
{
    
    
    NSString *shortCut = [[NSString alloc]init];
    
    if (day>7) {
        day = day-7;
        
    }
    
    switch (day) {
        case 1:
            shortCut = @"Sunday";
            break;
        case 2:
            shortCut = @"Monday";
            break;
        case 3:
            shortCut = @"Tuesday";
            break;
        case 4:
            shortCut = @"Wednesday";
            break;
        case 5:
            shortCut = @"thursday";
            break;
        case 6:
            shortCut = @"Friday";
            break;
        case 7:
            shortCut = @"Saturday";
            break;
            
        default:
            break;
    }
    return shortCut;
}

-(NSString *)getCelsius:(float)fahrenheit
{
    
    NSString *returnString = [NSString stringWithFormat:@"%.1f",(fahrenheit-32.0)*(5.0/9.0)];
    
    
    return returnString;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

