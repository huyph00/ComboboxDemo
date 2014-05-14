//
//  ComboboxView.h
//  ComboboxDemo
//
//  Created by NCXT on 08/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DOWN,
	UP
} dropBoxShowMode;
typedef enum {
    AND,
	OR
} search_type;
@protocol ComboboxViewDelegate

-(void)cellSelected:(id )returnObj;
-(void)btnDeleteSelected;
@end
@interface ComboboxView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *tbvDropBox;
    
    NSArray *arrData; //all data
    NSArray *arrDataToShow; //data to show

    BOOL isCheckBoxSelected;
    
    CGRect dropBoxRect;
    
    dropBoxShowMode showMode;
    
    CGFloat cellHeight;
    CGFloat lineSeparator;

    Class cellView;
    
    UIView *dropBoxView;
    
    id<ComboboxViewDelegate> delegate;
    id selectedObj;//selected object

    UIButton * clearButton;
    
    UITextField * textInput;
    
    search_type searchType;
 
    NSArray * arrSearchVariable;
    NSArray * arrObjProperties;
    
    NSString * strCustomCellName;//class custom cell
    
    NSTimer * disapearButtonTimer;
    
    NSDictionary *dicProperties;
    
    NSThread*  bgThread;

}
//@property(nonatomic) CGRect dropBoxRect;

@property(nonatomic) dropBoxShowMode showMode;

@property(nonatomic) CGFloat cellHeight;

@property(nonatomic) BOOL isCheckBoxSelected;

@property(nonatomic,strong) id selectedObj;

//@property(nonatomic,strong) UIView * dropBoxView;
@property (nonatomic,strong) id<ComboboxViewDelegate> delegate;

-(void)setCellView:(NSString *)className;
//set dropbox x and width
-(void)setDropBoxWidth:(CGFloat)width;
-(void)setDropBoxOrigin_x:(CGFloat)origin_x;

-(void)setDicProperties:(NSDictionary *)dic;

-(void)setDataArray:(NSArray *)data;

-(void)setLineSeparator:(CGFloat)lineHeight;

//search dic contain: string of variables and search function
-(void)setSearchType:(NSDictionary*)searchTypeDic;

-(id)initWithFrame:(CGRect)frame dataArray:(NSArray*)data  isCheckBox:(BOOL)isCheckBox cell:(NSString *)cellName font:(UIFont*)font textPlaceHolder:(NSString*)textPlaceHolder;
@end
