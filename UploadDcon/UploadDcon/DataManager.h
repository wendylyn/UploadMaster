//
//  DataManager.h
//  UploadDcon
//
//  Created by Xuyan Ke on 11/24/15.
//  Copyright © 2015 Xuyan Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property(nonatomic, readwrite, strong) NSString *repoPath;

+ (DataManager *)sharedInstance;

- (NSString *)repoPath;
- (void)setRepoPath:(NSString *)repoPath;

@end
