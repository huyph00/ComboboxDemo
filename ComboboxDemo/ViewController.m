//
//  ViewController.m
//  ComboboxDemo
//
//  Created by NCXT on 08/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray * arrData = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 10; i++) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setValue:@"cell" forKey:@"name"];
        [dic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"title"];
        [dic setObject:[UIImage imageNamed:@"rightArrow"] forKey:@"icon"];
        [arrData addObject:dic];
    }
    
    
    NSMutableDictionary * searchFunction= [[NSMutableDictionary alloc]init];
    [searchFunction setValue:@"AND" forKey:@"type"];
    [searchFunction setValue:[NSArray arrayWithObjects:@"title",@"name", nil] forKey:@"variable"];
    
    ComboboxView *cbView = [[ComboboxView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, 160, 30) dataArray:arrData isCheckBox:YES cell:@"DefaultCell" font:nil textPlaceHolder:@"Xin nhap du lieu"];
    [self.view addSubview:cbView];
    [cbView setShowMode:UP];
    [cbView setSearchType:searchFunction];
    cbView.delegate = self;
    
    
}
-(void)cellSelected:(id)returnCell
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
