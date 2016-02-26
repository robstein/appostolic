//
//  RASUtils.h
//  Appostolic
//
//  Created by Robert Stein on 1/18/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#ifndef RASUtils_h
#define RASUtils_h

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

// Use to 40.78.107.212:3000 for azure server
// Use localhost for local server
#define RASServerFormat @"http://40.78.107.212:3000/%@"
#define URLWithServerQuery(query) [NSString stringWithFormat:RASServerFormat, query];

#endif /* RASUtils_h */
