//
//  DayModel.m
//  Appostolic
//
//  Created by Robert Stein on 1/18/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "DayModel.h"
#import "Reading.h"
#import "Liturgy.h"
#import "Saint.h"
#import <RestKit/ObjectMapping/RKObjectMapping.h>
#import <RestKit/ObjectMapping/RKRelationshipMapping.h>
#import <RestKit/Network/RKResponseDescriptor.h>
#import <RestKit/Network/RKObjectRequestOperation.h>

NSString *const ReadingsServerURLFormat = @"http://localhost:3000/%@";

@implementation DayModel

- (instancetype)initForDate:(NSDate *)date {
    if (self = [super init]) {
        double millisecondsSince1970 = [date timeIntervalSince1970] * 1000;
        NSString *lastPathComponent = [NSString stringWithFormat:@"%.0f", millisecondsSince1970];
        NSString *urlString = [NSString stringWithFormat:ReadingsServerURLFormat, lastPathComponent];
        [self loadFromDataAtURL:[NSURL URLWithString:urlString]];
        // Send request to the url at urlString
    }
    return self;
}


- (void)loadFromDataAtURL:(NSURL *)url {
    RKObjectMapping *readingMapping = [RKObjectMapping mappingForClass:[Reading class]];
    [readingMapping addAttributeMappingsFromDictionary:@{
                                                  @"name":  @"name",
                                                  @"passage":   @"passage",
                                                  @"body":  @"body"
                                                  }];
    
    RKObjectMapping *liturgyMapping = [RKObjectMapping mappingForClass:[Liturgy class]];
    [liturgyMapping addAttributeMappingsFromDictionary:@{
                                                         @"name":  @"name",
                                                         @"body":  @"body"
                                                         }];
    
    RKObjectMapping *saintMapping = [RKObjectMapping mappingForClass:[Saint class]];
    [saintMapping addAttributeMappingsFromDictionary:@{
                                                         @"name":  @"name",
                                                         @"body":  @"body"
                                                         }];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[DayModel class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"title": @"title",
                                                  @"lectionary":    @"lectionary",
                                                  @"text":  @"text"
                                                  }];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"readings"
                                                                            toKeyPath:@"readings"
                                                                          withMapping:readingMapping]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"liturgyOfTheHours"
                                                                            toKeyPath:@"liturgyOfTheHours"
                                                                          withMapping:liturgyMapping]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"saints"
                                                                            toKeyPath:@"saints"
                                                                          withMapping:saintMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"The public timeline Tweets: %@", [result array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Shoot! %@", [error description]);
    }];
    [operation start];
}



@end
