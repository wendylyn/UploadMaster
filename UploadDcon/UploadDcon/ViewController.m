//
//  ViewController.m
//  UploadDcon
//
//  Created by Xuyan Ke on 11/24/15.
//  Copyright © 2015 Xuyan Ke. All rights reserved.
//

#import "ViewController.h"

#import "DataManager.h"

@interface ViewController ()

#define kDconRepoPath @"repoPath"

@property(nonatomic, readwrite, strong) NSMutableArray *tableContents;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    _consoleOutput.editable = NO;
    _consoleOutput.automaticSpellingCorrectionEnabled = NO;
    _tableContents = [[NSMutableArray alloc] init];
    _repoPath = [DataManager sharedInstance].repoPath;
    [self showUntrackedFiles];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)checkRepo {

}

- (void)showUntrackedFiles {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    NSString *gsPath = [[NSBundle mainBundle] pathForResource:@"Scripts/gs.sh" ofType:nil];
    [task setArguments: @[gsPath, self.repoPath]];

    NSPipe *out = [NSPipe pipe];
    [task setStandardOutput:out];

    [task launch];
    [task waitUntilExit];

    NSFileHandle *read = [out fileHandleForReading];

    NSData *dataRead = [read readDataToEndOfFile];
    NSString *stringRead = [[NSString alloc] initWithData:dataRead encoding:NSUTF8StringEncoding];

    [self addUntrackedFile:stringRead];
}

- (void)addUntrackedFile:(NSString *)output {
    [self.tableContents removeAllObjects];
    NSArray *brokenByLines=[output componentsSeparatedByString:@"\n"];
    for (NSString *line in brokenByLines) {
        if ([line length] > 0) {
            [self.tableContents addObject:line];
        }
    }
    [self.tableView reloadData];
}

- (void)commitAndUploadFiles {
    self.tableViewRoot.hidden = YES;

    NSString *filesToUpload = @"";

    for (NSString *filename in self.tableContents) {
        if ([filesToUpload length] > 2) {
            filesToUpload = [filesToUpload stringByAppendingString:@" "];
        }
        filesToUpload = [filesToUpload stringByAppendingString:filename];
    }

    //filesToUpload = [filesToUpload stringByAppendingString:@"\""];
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    NSString *cmPath = [[NSBundle mainBundle] pathForResource:@"Scripts/commitAndUpload.sh" ofType:nil];
    [task setArguments: @[cmPath, self.repoPath, filesToUpload]];

    NSPipe *out = [NSPipe pipe];
    [task setStandardOutput:out];
    [task launch];

    NSFileHandle *fh = [out fileHandleForReading];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedData:)
                                                 name:NSFileHandleDataAvailableNotification
                                               object:fh];
    [fh waitForDataInBackgroundAndNotify];

    [task waitUntilExit];


    //NSData *dataRead = [read readDataToEndOfFile];
    //NSString *stringRead = [[NSString alloc] initWithData:dataRead encoding:NSUTF8StringEncoding];

    //[self.consoleOutput setString:stringRead];
}

- (void)receivedData:(NSNotification *)notif {
    NSFileHandle *fh = [notif object];
    NSData *data = [fh availableData];

    if (data.length > 0) { // if data is found, re-register for more data (and print)
        [fh waitForDataInBackgroundAndNotify];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.consoleOutput.string = [self.consoleOutput.string stringByAppendingString:str];
        [self.consoleOutput scrollRangeToVisible: NSMakeRange(self.consoleOutput.string.length, 0)];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSFileHandleDataAvailableNotification
                                                      object:fh];
    }
}


#pragma mark UI Responders

- (IBAction)runTask:(id)sender {
    [self showUntrackedFiles];
}

- (IBAction)commitAndUpload:(id)sender {
    self.commitAndUploadBtn.enabled = NO;
    [self commitAndUploadFiles];
}


#pragma mark TableView delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_tableContents count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = [tableColumn identifier];
    if ([identifier isEqualToString:@"FilenameCellCol"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        [cellView.textField setStringValue:self.tableContents[row]];
        return cellView;
    }
    return nil;
}
@end
