//
//  ViewController.h
//  UploadDcon
//
//  Created by Xuyan Ke on 11/24/15.
//  Copyright © 2015 Xuyan Ke. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSButton *btn;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSScrollView *tableViewRoot;
@property (unsafe_unretained) IBOutlet NSTextView *consoleOutput;
@property (weak) IBOutlet NSButton *commitAndUploadBtn;



@property(nonatomic, readwrite, strong) NSString *repoPath;

@end

