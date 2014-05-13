//
//  ViewController.m
//  ComboboxDemo
//
//  Created by NCXT on 08/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import "ViewController.h"
#import "SampleObject.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray * arrData = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {

        SampleObject * obj = [[SampleObject alloc]init];
        obj.strDetail = [NSString stringWithFormat:@"Dt:%d",i];
        obj.strHeader = [NSString stringWithFormat:@"Hd:%d",i];
        obj.strSubDetail = [NSString stringWithFormat:@"SubDt:%d",i];
        obj.img = [UIImage imageNamed:@"rightArrow"];
        
        
        
        
        [arrData addObject:obj];
    }
    
    
    
    
    
    NSMutableDictionary * dicProperties = [NSMutableDictionary dictionary];
//    [dicProperties setObject:@"strDetail" forKey:@"lblTitle01"];
//    [dicProperties setObject:@"strHeader" forKey:@"lblHeader01"];
//    [dicProperties setObject:@"strSubDetail" forKey:@"lblSubDetail01"];
//    [dicProperties setObject:@"img" forKey:@"img01"];
    
    //test SampleTableViewCell
    [dicProperties setObject:@"strDetail" forKey:@"lblTitle02"];
    [dicProperties setObject:@"strHeader" forKey:@"lblHeader02"];
    [dicProperties setObject:@"strSubDetail" forKey:@"btnSubDetail02"];
    [dicProperties setObject:@"img" forKey:@"img02"];
    
    NSMutableDictionary * searchFunction= [[NSMutableDictionary alloc]init];
    [searchFunction setValue:@"OR" forKey:@"type"];
    [searchFunction setValue:[NSArray arrayWithObjects:@"strDetail",@"strHeader", nil] forKey:@"variable"];
    
//    NSString * strClassCellName = @"CustomCellWithXib";

    NSString * strClassCellName = @"SampleTableViewCell";
    
    ComboboxView *cbView = [[ComboboxView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, 200, 25) dataArray:arrData isCheckBox:YES cell:strClassCellName font:nil textPlaceHolder:@"Xin nhap du lieu"];
    [self.view addSubview:cbView];
    [cbView setShowMode:UP];
    
//    [cbView setDropBoxOrogin_x:100];
    [cbView setDropBoxWidth:300];

    [cbView setSearchType:searchFunction];
    [cbView setDicProperties:dicProperties];
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
