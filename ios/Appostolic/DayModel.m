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
#import <RestKit/RKObjectMapping.h>
#import <RestKit/RKRelationshipMapping.h>
#import <RestKit/RKResponseDescriptor.h>
#import <RestKit/RKObjectRequestOperation.h>

NSString *const ReadingsServerURLFormat = @"http://localhost:3000/%@";

@implementation DayModel

+ (void)loadDayModelForDate:(NSDate *)date {
    double millisecondsSince1970 = [date timeIntervalSince1970] * 1000;
    NSString *lastPathComponent = [NSString stringWithFormat:@"%.0f", millisecondsSince1970];
    NSString *urlString = [NSString stringWithFormat:ReadingsServerURLFormat, lastPathComponent];
    NSURL *url = [NSURL URLWithString:urlString];
    
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
        DayModel *model = [[result array] firstObject];
        NSLog(@"The day's data: %@", model);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModelLoaded" object:model];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Shoot! %@", [error description]);
    }];
    [operation start];
}



@end
