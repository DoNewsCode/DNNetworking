//
//  DNViewController.m
//  DNNetworking
//
//  Created by JKzzz on 12/19/2018.
//  Copyright (c) 2018 JKzzz. All rights reserved.
//

#import "DNViewController.h"
#import "DNUploadImageRequest.h"
#import <YYModel/YYModel.h>
@interface DNViewController ()

@end

@implementation DNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    DNUploadImageRequest *request = [[DNUploadImageRequest alloc] init];
    NSArray *arr = [DNUploadImageRequest performSelector:@selector(modelPropertyBlacklist)];
    NSLog(@"%@",arr);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
