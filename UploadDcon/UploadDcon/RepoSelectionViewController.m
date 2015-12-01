//
//  RepoSelectionViewController.m
//  UploadDcon
//
//  Created by Xuyan Ke on 11/24/15.
//  Copyright © 2015 Xuyan Ke. All rights reserved.
//

#import "RepoSelectionViewController.h"

#import "DataManager.h"
#import "ViewController.h"

@interface RepoSelectionViewController ()

@end

@implementation RepoSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

}
- (IBAction)confirmRepoSelection:(id)sender {

}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    [DataManager sharedInstance].repoPath = self.repoPathLabel.stringValue;
}


@end
