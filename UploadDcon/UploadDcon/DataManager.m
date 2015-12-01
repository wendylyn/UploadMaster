//
//  DataManager.m
//  UploadDcon
//
//  Created by Xuyan Ke on 11/24/15.
//  Copyright © 2015 Xuyan Ke. All rights reserved.
//

#import "DataManager.h"


@implementation DataManager

static DataManager *instance;

+ (DataManager *)sharedInstance {
    if (instance == nil) {
        instance = [[DataManager alloc] init];
    }
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.repoPath = nil;
    }
    return self;
}
@end
