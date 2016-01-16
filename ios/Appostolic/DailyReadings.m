//
//  DailyReadings.m
//  Appostolic
//
//  Created by Robert Stein on 1/13/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "DailyReadings.h"
#import "TFHpple.h"

static const NSUInteger DateDescriptionIndexOfMonth = 6;
static const NSUInteger DateDescriptionIndexOfDay = 9;
static const NSUInteger DateDescriptionIndexOfYear = 2;
static const NSUInteger DateDescriptionSubstringLength = 2;
NSString *const USSCBUrlFormat = @"https://www.usccb.org/bible/readings/%@%@%@.cfm";

@interface DailyReadings () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation DailyReadings

@synthesize responseData = _responseData;

- (instancetype)initForDate:(NSDate *)date {
    if (self = [super init]) {
        NSURL *url = [DailyReadings USCCBURLForDate:date];
        [self loadDataFromUrl:url];
    }
    return self;
}

- (void)loadDataFromUrl:(NSURL *)url {
    //NSData *htmlData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    //NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.raywenderlich.com/14172/how-to-parse-html-on-ios"] options:NSDataReadingUncached error:&error];
    
    
    //NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
    //                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
    //                                      timeoutInterval:60.0];

    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

+ (NSURL *)USCCBURLForDate:(NSDate *)date {
    NSString *dateStr = [date descriptionWithLocale:[NSLocale systemLocale]];
    NSString *month = [dateStr substringWithRange:NSMakeRange(DateDescriptionIndexOfMonth, DateDescriptionSubstringLength)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(DateDescriptionIndexOfDay, DateDescriptionSubstringLength)];
    NSString *year = [dateStr substringWithRange:NSMakeRange(DateDescriptionIndexOfYear, DateDescriptionSubstringLength)];
    
    NSString *urlString = [NSString stringWithFormat:USSCBUrlFormat, month, day, year];
    return [NSURL URLWithString:urlString];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];

}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    TFHpple *parser = [TFHpple hppleWithHTMLData:_responseData];
    NSArray *dayTitleNodes = [parser searchWithXPathQuery:@"//div[@class=\"CS_Textblock_Text\"]/h3"];
    NSArray *readingTitleNodes = [parser searchWithXPathQuery:@"//div[@class='bibleReadingsWrapper']/h4"];
    NSArray *readingBookAndVerseNodes = [parser searchWithXPathQuery:@"//div[@class='bibleReadingsWrapper']/h4/a"];
    NSArray *readingTextNodes = [parser searchWithXPathQuery:@"//div[@class='bibleReadingsWrapper']/div[@class='poetry']"];
    NSArray *extraTitleNodes = [parser searchWithXPathQuery:@"//div[@class='bibleReadingsWrapper']/div[@class='poetry']/h4"];
    NSArray *extraBookAndVerseNodes = [parser searchWithXPathQuery:@"//div[@class='bibleReadingsWrapper']/div[@class='poetry']/h4/a"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end

