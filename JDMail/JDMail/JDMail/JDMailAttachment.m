//
//  JDMailAttachment.m
//  JDMail
//
//  Created by 公司 on 2019/2/28.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDMailAttachment.h"

@implementation JDMailAttachment

- (NSString *)sizeStr
{
    double convertedValue = [self.size doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

@end
